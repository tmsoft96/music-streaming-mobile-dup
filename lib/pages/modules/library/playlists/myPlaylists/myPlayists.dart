import 'dart:convert';
import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:rally/bloc/myPlaylistsBloc.dart';
import 'package:rally/components/coolAlertDialog.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/offlineData.dart';
import 'package:rally/config/services.dart';
import 'package:rally/models/allPlaylistsModel.dart';
import 'package:rally/models/myPlaylistsModel.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/widget/previewPlaylistsWidget.dart';
import 'package:rally/pages/modules/library/playlists/playlistDetails/playlistDetails.dart';
import 'package:rally/spec/colors.dart';

import '../createPlaylists/createPlaylists.dart';

class MyPlaylists extends StatefulWidget {
  const MyPlaylists({Key? key}) : super(key: key);

  @override
  State<MyPlaylists> createState() => _MyPlaylistsState();
}

class _MyPlaylistsState extends State<MyPlaylists> {
  bool _isLoading = false;
  String _loadingMsg = "";
  double? _loadingPercentage;

  @override
  void initState() {
    super.initState();
    loadMyPlaylistsMapOffline(userModel!.data!.user!.userid, "2");
    myPlaylistsBloc.fetch(userModel!.data!.user!.userid, "2");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Playlists")),
      body: StreamBuilder(
        stream: myPlaylistsBloc.allPlaylists,
        initialData: myPlaylistsMapOffline == null
            ? null
            : MyPlaylistsModel.fromJson(
                json: myPlaylistsMapOffline,
                httpMsg: "Offline Data",
              ),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.ok)
              return _mainContent(snapshot.data);
            else
              return myPlaylistsMapOffline == null
                  ? emptyBox(
                      context,
                      msg: "${snapshot.data.msg}",
                      buttonText: "Create New Playlist",
                      onTap: () => _onCreatePlaylist(null),
                    )
                  : _mainContent(
                      MyPlaylistsModel.fromJson(
                        json: myPlaylistsMapOffline,
                        httpMsg: "Offline Data",
                      ),
                    );
          } else if (snapshot.hasError) {
            return emptyBox(
              context,
              msg: "No data available",
              buttonText: "Create New Playlist",
              onTap: () => _onCreatePlaylist(null),
            );
          }
          return shimmerItem();
        },
      ),
    );
  }

  Widget _mainContent(MyPlaylistsModel model) {
    return Stack(
      children: [
        previewPlaylistsWidget(
          context: context,
          onAddPlaylist: () => _onCreatePlaylist(null),
          onPlaylist: (MyPlaylistsData data) => _onPlaylist(data),
          model: model,
          onPopupAction: (String action, MyPlaylistsData data) =>
              _onPopupAction(action, data),
        ),
        if (_isLoading)
          customLoadingPage(
            msg: _loadingMsg,
            percent: _loadingPercentage,
          ),
      ],
    );
  }

  void _onPlaylist(MyPlaylistsData data) {
    AllPlaylistsData allPlaylistsData = AllPlaylistsData.fromJson(
      data.toJson(),
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlaylistDetails(allPlaylistsData),
      ),
    );
  }

  void _onCreatePlaylist(MyPlaylistsData? data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreatePlaylists(
          playerModel: null,
          myPlaylistsData: data,
        ),
      ),
    );
  }

  Future<void> _onPopupAction(String action, MyPlaylistsData data) async {
    if (action == "ed") {
      _onCreatePlaylist(data);
    } else if (action == "dl") {
      coolAlertDialog(
        context: context,
        onConfirmBtnTap: () => _onDeletePlaylist(data),
        type: CoolAlertType.warning,
        text:
            "You are about to delete this playlist. Understand that deleting is permanent, and can't be undone",
        confirmBtnText: "Delete Forever",
      );
    }
  }

  Future<void> _onDeletePlaylist(MyPlaylistsData data) async {
    _loadingMsg = "";
    setState(() => _isLoading = true);
    navigation(context: context, pageName: "back");
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: DELETECONTENTPLAYLISTS_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "playlists": json.encode([data.id.toString()]),
          "userid": userModel!.data!.user!.userid,
        },
      ),
      showToastMsg: false,
    );
    log("$httpResult");
    if (httpResult["ok"]) {
      await myPlaylistsBloc.fetch(userModel!.data!.user!.userid, "2");
      setState(() => _isLoading = false);
      toastContainer(text: httpResult["data"]["msg"], backgroundColor: GREEN);
    } else {
      setState(() => _isLoading = false);
      httpResult["statusCode"] == 200
          ? toastContainer(
              text: httpResult["data"]["msg"], backgroundColor: RED)
          : toastContainer(text: httpResult["error"], backgroundColor: RED);
    }
  }
}
