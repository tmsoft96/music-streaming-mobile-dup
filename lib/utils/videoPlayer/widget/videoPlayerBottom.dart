import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';
import 'package:video_player/video_player.dart';

Widget videoPlayerBottom({
  @required String? startTime,
  @required String? endTime,
  @required void Function()? onMute,
  @required void Function()? onPlay,
  @required void Function()? onRotate,
  @required void Function()? onRepeat,
  @required bool? isPlaying,
  @required bool? isRepeat,
  @required bool? isMute,
  @required VideoPlayerController? controller,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      VideoProgressIndicator(
        controller!,
        allowScrubbing: true,
        padding: EdgeInsets.all(10),
      ),
      SizedBox(height: 10),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$startTime", style: h6WhiteBold),
            Text("$endTime", style: h6WhiteBold),
          ],
        ),
      ),
      SizedBox(height: 10),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: onMute,
                  icon: Icon(
                    isMute! ? Icons.volume_off : Icons.volume_up,
                  ),
                  iconSize: 30,
                  color: BLACK,
                ),
                IconButton(
                  onPressed: onPlay,
                  icon: Icon(
                    isPlaying! ? Icons.pause : Icons.play_arrow_rounded,
                  ),
                  iconSize: 35,
                  color: BLACK,
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: onRepeat,
                  icon: Icon(Icons.repeat),
                  iconSize: 30,
                  color: isRepeat! ? PRIMARYCOLOR : BLACK,
                ),
                IconButton(
                  onPressed: onRotate,
                  icon: Icon(FeatherIcons.maximize),
                  iconSize: 25,
                  color: BLACK,
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
