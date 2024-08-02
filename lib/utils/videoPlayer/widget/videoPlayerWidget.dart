import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

Widget videoPlayerWidget({
  @required VideoPlayerController? controller,
}) {
  return Center(
    child: controller!.value.isInitialized
        ? AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          )
        : Container(),
  );
}
