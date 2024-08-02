import 'dart:developer';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/downloadFIle.dart';
import 'package:rally/config/http/others/httpAddBroadcast.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/properties.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';
import 'package:record/record.dart';

import 'widget/adminBroadcastWidget.dart';
import 'widget/braodcastSuccessDialog.dart';

class AdminBroadcast extends StatefulWidget {
  final PlayerModel? playerModel;

  AdminBroadcast(this.playerModel);

  @override
  State<AdminBroadcast> createState() => _AdminBroadcastState();
}

class _AdminBroadcastState extends State<AdminBroadcast> {
  late final RtcEngine _engine;
  final _record = Record();

  bool _isJoined = false, _isBroadcastEnd = false, _isLoading = false;
  // openMicrophone = true,
  // enableSpeakerphone = true,
  // playEffect = false;
  // bool _enableInEarMonitoring = false;
  // double _recordingVolume = 100,
  //     _playbackVolume = 100,
  //     _inEarMonitoringVolume = 100;

  String? _recordingFilePath;

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    _engine.destroy();
  }

  _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(AGORA_APP_ID));
    _addListeners();

    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  Future<void> _onRecord() async {
    // geting path
    String fileName = new DateTime.now().millisecondsSinceEpoch.toString();
    _recordingFilePath = await getFilePath("$TITLE$fileName");
    _recordingFilePath = "$_recordingFilePath.mp3";

    // Check and request permission
    if (await _record.hasPermission()) {
      // Start recording
      await _record.start(
        path: '$_recordingFilePath',
        encoder: AudioEncoder.aacLc, // by default
        bitRate: 128000, // by default
      );
    }

    // Get the state of the recorder
    bool isRecording = await _record.isRecording();
    log("isRecording $isRecording");
  }

  void _addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
      warning: (warningCode) {
        log('warning $warningCode');
      },
      error: (errorCode) {
        log('error $errorCode');
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        log('joinChannelSuccess $channel $uid $elapsed');
        setState(() {
          _isJoined = true;
        });
      },
      leaveChannel: (stats) async {
        log('leaveChannel ${stats.toJson()}');
        setState(() {
          _isJoined = false;
        });
      },
    ));
  }

  void _joinChannel() async {
    if (Platform.isAndroid) {
      await Permission.microphone.request();
    }

    await _engine
        .joinChannel(null, widget.playerModel!.data![0].id!.toString(), null, 0)
        .then((value) async {
      await _onRecord();
    }).catchError((onError) {
      log('error ${onError.toString()}');
    });
  }

  void _leaveChannel() async {
    await _engine.leaveChannel();
    setState(() {
      _isJoined = false;
      // openMicrophone = true;
      // enableSpeakerphone = true;
      // playEffect = false;
      // _enableInEarMonitoring = false;
      // _recordingVolume = 100;
      // _playbackVolume = 100;
      // _inEarMonitoringVolume = 100;
    });
    // Stop recording
    await _record.stop();
    _isBroadcastEnd = true;
    // navigation(context: context, pageName: "back");
  }

  // void _switchMicrophone() async {
  //   // await _engine.muteLocalAudioStream(!openMicrophone);
  //   await _engine.enableLocalAudio(!openMicrophone).then((value) {
  //     setState(() {
  //       openMicrophone = !openMicrophone;
  //     });
  //   }).catchError((err) {
  //     log('enableLocalAudio $err');
  //   });
  // }

  // void _switchSpeakerphone() {
  //   _engine.setEnableSpeakerphone(!enableSpeakerphone).then((value) {
  //     setState(() {
  //       enableSpeakerphone = !enableSpeakerphone;
  //     });
  //   }).catchError((err) {
  //     log('setEnableSpeakerphone $err');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: BACKGROUND,
          leading: SizedBox(),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundColor: PRIMARYCOLOR,
                child: IconButton(
                  onPressed: () => _leaveChannel(),
                  icon: Icon(Icons.close_rounded),
                  color: BLACK,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            adminBroadcastWidget(
              context: context,
              onRemove: () {},
              onSend: () {},
              textController: null,
              textFocusNode: null,
              onPlay: () => _isJoined ? _leaveChannel() : _joinChannel(),
              isPlaying: _isJoined,
              playerModel: widget.playerModel,
            ),
            if (_isBroadcastEnd) ...[
              Container(color: BLACK.withOpacity(.7)),
              braodcastSuccessDialog(
                context: context,
                onPlay: () => _onPlayRecording(),
                onSubmitHome: () => _onSubmitHome(),
              ),
            ],
            if (_isLoading) customLoadingPage(),
          ],
        ),
      ),
    );
  }

  void _onPlayRecording() {
    Map<String, dynamic> json = {
      "data": [
        {
          "id": -1000,
          "title": widget.playerModel!.data![0].title,
          "lyrics": widget.playerModel!.data![0].lyrics,
          "stageName": widget.playerModel!.data![0].stageName,
          "filepath": _recordingFilePath,
          "cover": widget.playerModel!.data![0].cover,
          "isCoverLocal": false,
          "description": widget.playerModel!.data![0].description,
          "isFileLocal": true,
          "artistId": widget.playerModel!.data![0].artistId,
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
  }

  Future<void> _onSubmitHome() async {
    setState(() => _isLoading = true);
    Map<String, dynamic> meta = {
      "title": widget.playerModel!.data![0].title,
      "cover": widget.playerModel!.data![0].cover,
      "dateTime": widget.playerModel!.data![0].duration,
      "status": "0",
      "tags": widget.playerModel!.data![0].tags,
      "description": widget.playerModel!.data![0].description,
      "contents": [File(_recordingFilePath!)],
      "isUpdate": true,
      "isLocalImage": false,
      "isLocalContent": true,
      "editContentPath": _recordingFilePath,
      "postId": widget.playerModel!.data![0].id.toString(),
      "timezone": widget.playerModel!.data![0].tempDuration,
    };
    await httpAddBroadcast(
      meta: meta,
      onFunction: (Map<String, dynamic>? data) {
        setState(() => _isLoading = false);
        if (data != null && data["ok"]) {
          navigation(context: context, pageName: "adminHomepage");
        } else {
          toastContainer(text: "Error occured...", backgroundColor: RED);
        }
      },
    );
  }
}
