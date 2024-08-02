import 'dart:developer';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/spec/properties.dart';

import 'widget/livePlayerWidget.dart';

class LivePlayer extends StatefulWidget {
  final PlayerModel? playerModel;

  LivePlayer(this.playerModel);

  @override
  _LivePlayerState createState() => _LivePlayerState();
}

class _LivePlayerState extends State<LivePlayer> {
  late final RtcEngine _engine;
  bool _isJoined = false;

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
    await _engine.setClientRole(ClientRole.Audience);
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
        .catchError((onError) {
      log('error ${onError.toString()}');
    });
  }

  void _leaveChannel() async {
    await _engine.leaveChannel();
    setState(() {
      _isJoined = false;
    });
    navigation(context: context, pageName: "back");
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: livePlayerWidget(
        context: context,
        isPlaying: _isJoined,
        onPlay: () => _isJoined ? _leaveChannel() : _joinChannel(),
        playerModel: widget.playerModel,
      ),
    );
  }
}
