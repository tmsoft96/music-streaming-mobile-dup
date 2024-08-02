import 'dart:developer';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rally/bloc/allPodcastBloc.dart';
import 'package:rally/components/coolAlertDialog.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/services.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/pages/modules/account/reportContent/addReport.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';
import 'package:rally/utils/livePlayer/livePlayer.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

import 'widget/podcastDetailsWidget.dart';

class PodcastcastDetailsPage extends StatefulWidget {
  final AllRadioData? allRadioData;

  PodcastcastDetailsPage({@required this.allRadioData});

  @override
  _PodcastcastDetailsPageState createState() => _PodcastcastDetailsPageState();
}

class _PodcastcastDetailsPageState extends State<PodcastcastDetailsPage> {
  bool _isLoading = false, _isCompleteDownload = true;
  String _loadingMsg = "", _downloadingFilePath = "";
  double? _loadingPercentage;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onCheckDownloadingFile();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            podcastDetailsWidget(
              context: context,
              onPlay: () => _onCheckDateTime(),
              onMoreDescription: () => _onMoreDescription(),
              onRating: (double rating) => _onRating(rating),
              onWriteReview: () {},
              onBack: () => navigation(context: context, pageName: "back"),
              data: widget.allRadioData,
              onMorePopUp: (String action) => _onMorePopUp(action),
            ),
            if (_isLoading)
              customLoadingPage(
                msg: _loadingMsg,
                percent: _loadingPercentage,
              ),
          ],
        ),
      ),
    );
  }

  void _onMorePopUp(String action) {
    if (action == "rc") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (content) => AddReport(
            albumId: null,
            postId: null,
            radioId: widget.allRadioData!.id!.toString(),
          ),
        ),
      );
    }
  }

  void _onMoreDescription() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(10),
          color: BACKGROUND,
          child: Text("${widget.allRadioData!.description}", style: h6White),
        ),
      ),
    );
  }

  Future<void> _onRating(double rating) async {
    setState(() => _isLoading = true);
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: RATEPODCAST_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "userid": userModel!.data!.user!.userid,
          "post_id": widget.allRadioData!.id!.toString(),
          "rate": rating.round().toString(),
        },
      ),
      showToastMsg: false,
    );
    log("$httpResult");
    if (httpResult["ok"]) {
      allPodcastBloc.fetch();
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

  void _onCheckDateTime() {
    List<String> d = widget.allRadioData!.startDate!.split(' ')[0].split("-");
    List<String> t = widget.allRadioData!.startDate!
        .split(' ')[1]
        .substring(0, 5)
        .split(":");
    final date1 = DateTime(
      int.parse(d[0]),
      int.parse(d[1]),
      int.parse(d[2]),
      int.parse(t[0]),
      int.parse(t[1]),
    );
    final date2 = DateTime.now();
    final difference = date2.difference(date1).inSeconds;
    if (difference >= 0)
      _onStartBroadcast();
    else
      coolAlertDialog(
        context: context,
        onConfirmBtnTap: () => navigation(context: context, pageName: "back"),
        type: CoolAlertType.info,
        text: "Broadcast time not up yet",
        confirmBtnText: "Close",
      );
  }

  Future<void> _onStartBroadcast() async {
    setState(() => _isLoading = true);
    // counting streams
    httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: STREAMPODCAST_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "userid": userModel!.data!.user!.userid,
          "post_id": widget.allRadioData!.id!.toString(),
        },
      ),
      showToastMsg: false,
    );
    allPodcastBloc.fetch();
    setState(() => _isLoading = false);
    if (widget.allRadioData!.public == "0") {
      Map<String, dynamic> json = {
        "data": [
          {
            "id": widget.allRadioData!.id,
            "title": widget.allRadioData!.title,
            "lyrics": widget.allRadioData!.lyrics,
            "stageName": widget.allRadioData!.stageName,
            "filepath": widget.allRadioData!.filepath,
            "cover": widget.allRadioData!.cover,
            "isCoverLocal": false,
            "description": widget.allRadioData!.description,
            "artistId": widget.allRadioData!.userid,
          },
        ],
      };
      onHideOverlay();
      PlayerModel playerModel = PlayerModel.fromJson(json);
      final musicInitialize = MusicInitialize(playerModel: playerModel);
      if (player != null) musicInitialize.dispose();
      musicInitialize.init();
      setState(() => _isLoading = false);
      showMaterialModalBottomSheet(
        context: context,
        expand: false,
        enableDrag: false,
        backgroundColor: TRANSPARENT,
        builder: (context) => MusicPlayer(playerModel: playerModel),
      );
    } else {
      setState(() => _isLoading = false);
      Map<String, dynamic> json = {
        "data": [
          {
            "id": widget.allRadioData!.id,
            "title": widget.allRadioData!.title,
            "lyrics": widget.allRadioData!.lyrics,
            "stageName": widget.allRadioData!.stageName,
            "filepath": null,
            "cover": widget.allRadioData!.cover,
            "isCoverLocal": false,
            "description": widget.allRadioData!.description,
            "artistId": widget.allRadioData!.userid,
          },
        ],
      };
      PlayerModel playerModel = PlayerModel.fromJson(json);
      showMaterialModalBottomSheet(
        context: context,
        expand: false,
        enableDrag: false,
        backgroundColor: TRANSPARENT,
        builder: (context) => LivePlayer(playerModel),
      );
    }
  }

  Future<void> _onCheckDownloadingFile() async {
    if (_isCompleteDownload) {
      navigation(context: context, pageName: "back");
      return;
    }

    _isLoading = true;
    _loadingMsg = "Please wait...";
    setState(() {});

    // deleting file cus its not downloaded completely
    bool isExit = await File(_downloadingFilePath).exists();
    print("is exit $isExit");
    if (isExit) {
      File file = File(_downloadingFilePath);
      await file.delete();
    }

    if (isExit)
      _onCheckDownloadingFile();
    else
      navigation(context: context, pageName: "back");
  }
}
