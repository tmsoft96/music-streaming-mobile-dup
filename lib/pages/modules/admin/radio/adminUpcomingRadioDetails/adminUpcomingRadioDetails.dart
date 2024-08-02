import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rally/bloc/allPodcastBloc.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/coolAlertDialog.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/downloadFIle.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/services.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/pages/modules/admin/radio/addRadio/addRadio.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/adminBroadcast/adminBroadcast.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

import 'widget/adminUpcomingRadioDetailsWidget.dart';

class AdminUpcomingRadioDetails extends StatefulWidget {
  final AllRadioData? allRadioData;

  AdminUpcomingRadioDetails(this.allRadioData);

  @override
  State<AdminUpcomingRadioDetails> createState() =>
      _AdminUpcomingRadioDetailsState();
}

class _AdminUpcomingRadioDetailsState extends State<AdminUpcomingRadioDetails> {
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
        appBar: AppBar(
          title: Text("Upcoming"),
          actions: [
            IconButton(
              onPressed: () => _onDeleteDialog(),
              icon: Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () => _onEdit(),
              icon: Icon(Icons.edit),
            ),
          ],
        ),
        body: Stack(
          children: [
            adminUpcomingRadioDetailsWidget(
              context: context,
              data: widget.allRadioData,
            ),
            if (_isLoading)
              customLoadingPage(
                msg: _loadingMsg,
                percent: _loadingPercentage,
              ),
          ],
        ),
        bottomNavigationBar: _isLoading
            ? null
            : Padding(
                padding: EdgeInsets.all(10),
                child: button(
                  onPressed: () => _onStartBroadcast(),
                  text: widget.allRadioData!.public == "0"
                      ? "Play Broadcast"
                      : "Start Broadcast",
                  color: PRIMARYCOLOR,
                  context: context,
                ),
              ),
      ),
    );
  }

  void _onEdit() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddRadio(allRadioData: widget.allRadioData),
      ),
    );
  }

  void _onDeleteDialog() {
    coolAlertDialog(
      context: context,
      onConfirmBtnTap: () => _onDelete(),
      type: CoolAlertType.warning,
      text:
          "You are about to delete this content. Understant that deleting is permanent, and can't be undone",
      confirmBtnText: "Delete Forever",
    );
  }

  Future<void> _onDelete() async {
    navigation(context: context, pageName: "back");
    setState(() => _isLoading = true);
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: DELETEPODCAST_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "userid": userModel!.data!.user!.userid,
          "posts": json.encode([widget.allRadioData!.id.toString()]),
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

  Future<void> _onStartBroadcast() async {
    setState(() => _isLoading = true);
    String localPath = "";

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
    if (widget.allRadioData!.public == "0") {
      String fileUrl = widget.allRadioData!.filepath!;

      String fileName = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);
      String filePath = await getFilePath(fileName);

      _downloadingFilePath = filePath;

      await downloadFile(
        fileUrl,
        filePath: filePath,
        onProgress: (int rec, int total, String percentCompletedText,
            double percentCompleteValue) {
          print("$rec $total");
          _isCompleteDownload = false;
          print(_isCompleteDownload);
          setState(() {
            _loadingMsg = percentCompletedText;
            _loadingPercentage = percentCompleteValue;
          });
        },
        onDownloadComplete: (String? savePath) async {
          setState(() => _isLoading = false);
          localPath = savePath!;
          _isCompleteDownload = true;
          print(_isCompleteDownload);
        },
      );
      Map<String, dynamic> json = {
        "data": [
          {
            "id": widget.allRadioData!.id,
            "title": widget.allRadioData!.title,
            "lyrics": widget.allRadioData!.lyrics,
            "stageName": widget.allRadioData!.stageName,
            "filepath": localPath,
            "cover": widget.allRadioData!.cover,
            "isCoverLocal": false,
            "description": widget.allRadioData!.description,
            "isFileLocal": true,
            "artistId": widget.allRadioData!.userid,
          },
        ],
      };
      onHideOverlay();
      PlayerModel playerModel = PlayerModel.fromJson(json);
      final musicInitialize = MusicInitialize(playerModel: playerModel);
      if (player != null) musicInitialize.dispose();
      musicInitialize.init();
      showMaterialModalBottomSheet(
        context: context,
        expand: false,
        enableDrag: false,
        backgroundColor: TRANSPARENT,
        builder: (context) => MusicPlayer(playerModel: playerModel),
      );
    } else {
      setState(() => _isLoading = false);
      Map<String, dynamic> meta = {
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
            "tags": widget.allRadioData!.tags,
            "duration": widget.allRadioData!.startDate,
            "tempDuration": widget.allRadioData!.timezone,
          },
        ],
      };
      PlayerModel playerModel = PlayerModel.fromJson(meta);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AdminBroadcast(playerModel),
        ),
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
