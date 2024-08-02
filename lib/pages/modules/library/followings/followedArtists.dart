import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rally/bloc/allFollowersBloc.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/offlineData.dart';
import 'package:rally/config/services.dart';
import 'package:rally/models/allFollowersModel.dart';
import 'package:rally/spec/colors.dart';

import '../../artists/allContents/allContentsPage.dart';
import 'widget/followedArtistsWidget.dart';

class FollowedArtists extends StatefulWidget {
  const FollowedArtists({Key? key}) : super(key: key);

  @override
  State<FollowedArtists> createState() => _FollowedArtistsState();
}

class _FollowedArtistsState extends State<FollowedArtists> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadAllFollowerMapOffline(isFetchFollowers: false);
    allFollowersBloc.fetch(
      userModel!.data!.user!.userid!,
      isFetchFollowers: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Followed Artists")),
      body: StreamBuilder(
        stream: allFollowersBloc.allFollow,
        initialData: allFollowersMapOffline == null
            ? null
            : AllFollowersModel.fromJson(
                json: allFollowersMapOffline,
                httpMsg: "Offline Data",
              ),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.ok)
              return _mainContent(snapshot.data);
            else
              return allFollowersMapOffline == null
                  ? emptyBox(context, msg: "${snapshot.data.msg}")
                  : _mainContent(
                      AllFollowersModel.fromJson(
                        json: allFollowersMapOffline,
                        httpMsg: "Offline Data",
                      ),
                    );
          } else if (snapshot.hasError) {
            return emptyBox(context, msg: "No data available");
          }
          return shimmerItem();
        },
      ),
    );
  }

  Widget _mainContent(AllFollowersModel model) {
    return Stack(
      children: [
        followedArtistsWidget(
          context: context,
          model: model,
          onUser: (Data data) => _onUser(data),
          onUnfollow: (Data data) => _onUnfollow(data),
        ),
        if (_isLoading) customLoadingPage(),
      ],
    );
  }

  Future<void> _onUnfollow(Data data) async {
    setState(() => _isLoading = true);
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: FOLLOW_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "userid": data.userid,
          "follower": userModel!.data!.user!.userid,
        },
      ),
      showToastMsg: false,
    );
    log("$httpResult");
    if (httpResult["ok"]) {
      setState(() => _isLoading = false);
      allFollowersBloc.fetch(
        userModel!.data!.user!.userid!,
        isFetchFollowers: false,
      );
      toastContainer(text: httpResult["data"]["msg"], backgroundColor: GREEN);
    } else {
      setState(() => _isLoading = false);
      httpResult["statusCode"] == 200
          ? toastContainer(
              text: httpResult["data"]["msg"], backgroundColor: RED)
          : toastContainer(text: httpResult["error"], backgroundColor: RED);
    }
  }

  void _onUser(Data data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AllContents(
          artistId: data.userid,
          artistName: data.user!.stageName ?? data.user!.name,
          artistEmail: data.user!.email,
          artistPicture: data.user!.picture,
          followersCount: data.followersCount,
          followersUserIdList: [userModel!.data!.user!.userid!],
          streamsCount: data.streamsCount,
        ),
      ),
    );
  }
}
