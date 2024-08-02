import 'dart:convert';
import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/coolAlertDialog.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/offlineData.dart';
import 'package:rally/config/services.dart';
import 'package:rally/models/allArtistsModel.dart';
import 'package:rally/models/allFollowersModel.dart';
import 'package:rally/pages/authentication/resetPassword/resetPassword.dart';
import 'package:rally/pages/modules/admin/completeArtistEnrollment/completeArtistEnrollment.dart';
import 'package:rally/pages/modules/artists/artistContent/allArtistContent/allArtistContent.dart';
import 'package:rally/pages/modules/artists/uploadContent/uploadContent1/uploadContent1.dart';
import 'package:rally/providers/allFollowersProvider.dart';
import 'package:rally/providers/allMusicProvider.dart';
import 'package:rally/spec/colors.dart';

import '../adminViewAllArtist/enrollArtist/adminEnrollArtist.dart';
import 'widget/adminArtistDetailsWidget.dart';
import 'widget/adminPopup.dart';

class AdminArtistDetails extends StatefulWidget {
  final AllArtistData? data;

  AdminArtistDetails(this.data);

  @override
  State<AdminArtistDetails> createState() => _AdminArtistDetailsState();
}

class _AdminArtistDetailsState extends State<AdminArtistDetails> {
  AllFollowersModel? _allFollowersModel;

  int _tabIndex = 0;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAllFollower();
    _loadAllMusic();
  }

  Future<void> _loadAllFollower() async {
    AllFollowersProvider provider = AllFollowersProvider();
    await loadAllFollowerMapOffline();
    if (allFollowersMapOffline != null) {
      _allFollowersModel = AllFollowersModel.fromJson(
        json: allFollowersMapOffline,
        httpMsg: "Offline Data",
      );
      setState(() {});
    }
    _allFollowersModel = await provider.fetch(widget.data!.userid);
    setState(() {});
  }

  Future<void> _loadAllMusic() async {
    AllMusicProvider provider = AllMusicProvider();
    await provider.get(isLoad: true, filterArtistId: widget.data!.userid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        actions: [
          adminPopup(onAction: (String action) => _onPopup(action)),
        ],
      ),
      body: Stack(
        children: [
          adminArtistDetailsWidget(
            context: context,
            onArtist: () {},
            onAddContent: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UploadContent1(
                  artistId: widget.data!.userid,
                  stageName: widget.data!.stageName ?? widget.data!.name,
                ),
              ),
            ),
            onSeeAllHits: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllArtistContent(
                  artistId: widget.data!.userid,
                ),
              ),
            ),
            allFollowersModel: _allFollowersModel,
            allMusicModel: allMusicModel,
            onTap: (int index) {
              setState(() {
                _tabIndex = index;
              });
            },
            tabIndex: _tabIndex,
            data: widget.data,
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
    );
  }

  void _onPopup(String action) {
    if (action == "rs") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResetPassword(userId: widget.data!.userid),
        ),
      );
    } else if (action == "ep") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CompleteArtistEnrollment(
            allArtistData: widget.data,
            isEdit: true,
          ),
        ),
      );
    } else if (action == "ds") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AdminEnrollArtist(widget.data),
        ),
      );
    } else if (action == "stu") {
      coolAlertDialog(
        context: context,
        onConfirmBtnTap: () => _onSwitchToUser(),
        type: CoolAlertType.warning,
        text: "You are sure you want to switch artist to regular user",
        confirmBtnText: "Delete Forever",
      );
    } else if (action == "da") {
      coolAlertDialog(
        context: context,
        onConfirmBtnTap: () => _onDisableAccount(),
        type: CoolAlertType.warning,
        text: "You are sure you want to diable artist account",
        confirmBtnText: "Delete Forever",
      );
    }
  }

  Future<void> _onSwitchToUser() async {
    navigation(context: context, pageName: "back");
    setState(() => _isLoading = true);
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: SWITCHTOUSERARTIST_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "userid": widget.data!.userid,
          "verified": 0,
          "modifyuser": userModel!.data!.user!.userid,
        },
      ),
      showToastMsg: false,
    );
    log("$httpResult");
    if (httpResult["ok"]) {
      setState(() => _isLoading = false);
      toastContainer(text: httpResult["data"]["msg"], backgroundColor: GREEN);
      navigation(context: context, pageName: "adminhomepage");
    } else {
      setState(() => _isLoading = false);
      httpResult["statusCode"] == 200
          ? toastContainer(
              text: httpResult["data"]["msg"], backgroundColor: RED)
          : toastContainer(text: httpResult["error"], backgroundColor: RED);
    }
  }

  Future<void> _onDisableAccount() async {
    navigation(context: context, pageName: "back");
    setState(() => _isLoading = true);
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: DELETERESTOREARTIST_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "status": 0,
          "artists": json.encode([widget.data!.userid]),
          "modifyuser": userModel!.data!.user!.userid,
        },
      ),
      showToastMsg: false,
    );
    log("$httpResult");
    if (httpResult["ok"]) {
      setState(() => _isLoading = false);
      toastContainer(text: httpResult["data"]["msg"], backgroundColor: GREEN);
      navigation(context: context, pageName: "artisthomepage");
    } else {
      setState(() => _isLoading = false);
      httpResult["statusCode"] == 200
          ? toastContainer(
              text: httpResult["data"]["msg"], backgroundColor: RED)
          : toastContainer(text: httpResult["error"], backgroundColor: RED);
    }
  }
}
