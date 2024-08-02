import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/pages/modules/account/reportContent/addReport.dart';
import 'package:rally/pages/modules/radio/podcastDetails/widget/podcastPopup.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';
import 'package:rally/utils/videoPlayer/widget/videoPlayerWidget.dart';
import 'package:video_player/video_player.dart';

import 'widget/videoPlayerBottom.dart';

class VideoMusicPlayer extends StatefulWidget {
  final PlayerModel? playerModel;

  VideoMusicPlayer(this.playerModel);

  @override
  State<VideoMusicPlayer> createState() => _VideoMusicPlayerState();
}

class _VideoMusicPlayerState extends State<VideoMusicPlayer> {
  VideoPlayerController? _controller;

  String _startTime = "", _endTime = "";
  bool _isPlaying = true,
      _isLoop = false,
      _isMute = false,
      _isFullScreen = false,
      _showActions = true;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
    _controller!.pause();
    _controller!.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _loadVideo() {
    _controller = VideoPlayerController.file(
      File(widget.playerModel!.data![0].filepath!),
    );

    _controller!.addListener(() {
      int shours = _controller!.value.position.inHours;
      int sminutes = _controller!.value.position.inMinutes;
      int sseconds = _controller!.value.position.inSeconds;

      _startTime =
          "${shours == 0 ? '' : '$shours:'}${sminutes.toString().length == 1 ? '0$sminutes' : '$sminutes'}:${sseconds.toString().length == 1 ? '0$sseconds' : '$sseconds'}";

      int rhours = _controller!.value.duration.inHours;
      int rminutes = _controller!.value.duration.inMinutes;
      int rseconds = _controller!.value.duration.inSeconds;

      _endTime =
          "${rhours == 0 ? '' : '$rhours:'}${rminutes.toString().length == 1 ? '0$rminutes' : '$rminutes'}:${rseconds.toString().length == 1 ? '0$rseconds' : '$rseconds'}";

      _isPlaying = _controller!.value.isPlaying;
      setState(() {});
    });
    _controller!.setLooping(_isLoop);
    _controller!.initialize().then((_) => setState(() {}));
    _controller!.play();

    _isPlaying = true;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: !_showActions && _isFullScreen
          ? null
          : AppBar(
              backgroundColor: WHITE,
              centerTitle: false,
              title: Text(
                "${widget.playerModel!.data![0].title}",
                style: h5White,
              ),
              actions: [
                podcastPopup(
                  onAction: (String action) => _onMorePopUp(action),
                ),
              ],
            ),
      body: GestureDetector(
        onTap: () => _actionsVisibility(),
        child: videoPlayerWidget(controller: _controller),
      ),
      bottomNavigationBar: !_showActions && _isFullScreen
          ? null
          : SafeArea(
              child: videoPlayerBottom(
                endTime: _endTime,
                startTime: _startTime,
                isPlaying: _isPlaying,
                onPlay: () => _onPlayOrPause(),
                onMute: () => _onMute(),
                onRotate: () => _onRotate(),
                controller: _controller,
                isRepeat: _isLoop,
                onRepeat: () => _onLoop(),
                isMute: _isMute,
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
            postId: widget.playerModel!.data![0].id,
            radioId: null,
          ),
        ),
      );
    }
  }

  void _actionsVisibility() {
    if (_isFullScreen && !_showActions) {
      _showActions = true;
      if (mounted) setState(() {});
      _timer = Timer.periodic(Duration(seconds: 7), (timer) {
        _showActions = false;
        if (mounted) setState(() {});
        _timer!.cancel();
      });
    } else if (_showActions) {
      _showActions = false;
      if (mounted) setState(() {});
    }
  }

  void _onRotate() {
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    }
    _isFullScreen = !_isFullScreen;
    _showActions = !_showActions;
  }

  void _showHideStatusBar() {
    if (_isFullScreen)
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    else
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
  }

  void _onMute() {
    if (_isMute) {
      _controller!.setVolume(1);
      _isMute = false;
    } else {
      _controller!.setVolume(0);
      _isMute = true;
    }
    setState(() {});
    _showHideStatusBar();
  }

  void _onPlayOrPause() {
    if (_isPlaying) {
      _controller!.pause();
      _isPlaying = false;
    } else {
      _controller!.play();
      _isPlaying = true;
    }
    setState(() {});
    _showHideStatusBar();
  }

  void _onLoop() {
    if (_isLoop) {
      _controller!.setLooping(false);
      _isLoop = false;
    } else {
      _controller!.setLooping(true);
      _isLoop = true;
    }
    setState(() {});
    _showHideStatusBar();
  }
}
