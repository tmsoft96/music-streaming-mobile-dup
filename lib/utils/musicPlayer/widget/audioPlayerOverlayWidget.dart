import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget audioPlayerOverlayWidget({
  @required BuildContext? context,
  @required Offset? offset,
  @required void Function(DragUpdateDetails details)? onPanUpdate,
  @required void Function()? onPlayOrPause,
  @required void Function()? onClose,
  @required void Function()? onTap,
  @required bool? isPlaying,
  @required AudioPlayer? player,
}) {
  return Positioned(
    left: offset!.dx,
    top: offset.dy,
    child: GestureDetector(
      onPanUpdate: (details) => onPanUpdate!(details),
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context!).size.width * .7,
        height: 50,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: PRIMARYCOLOR.withOpacity(.9),
        ),
        child: StreamBuilder<SequenceState?>(
          stream: player!.sequenceStateStream,
          builder: (context, snapshot) {
            final state = snapshot.data;
            if (state?.sequence.isEmpty ?? true) {
              return const SizedBox();
            }
            final metadata = state!.currentSource!.tag as MediaItem;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                circular(
                  borderColor: PRIMARYCOLOR.withOpacity(.8),
                  child: !metadata.extras!["isCoverLocal"]!
                      ? cachedImage(
                          context: context,
                          image: metadata.artUri.toString(),
                          height: 50,
                          width: 50,
                          placeholder: NOAUDIOCOVER,
                          diskCache: 150,
                        )
                      : Image.file(
                          File(metadata.artUri.toString()),
                          height: 50,
                          width: 50,
                        ),
                  size: 50,
                ),
                Container(
                  width: (MediaQuery.of(context).size.width * .7) - 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        color: TRANSPARENT,
                        child: Text(
                          "${metadata.title}",
                          style: h6BlackBold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Material(
                        color: TRANSPARENT,
                        child: Text(
                          "${metadata.artist}",
                          style: h7Black,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    button(
                      onPressed: onPlayOrPause,
                      text: null,
                      icon: Icon(
                        isPlaying! ? Icons.pause : Icons.play_arrow_rounded,
                        size: 30,
                      ),
                      color: TRANSPARENT,
                      context: context,
                      divideWidth: .085,
                      padding: EdgeInsets.zero,
                    ),
                    SizedBox(width: 2),
                    button(
                      onPressed: onClose,
                      text: null,
                      icon: Icon(Icons.close, size: 30),
                      color: TRANSPARENT,
                      context: context,
                      divideWidth: .085,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}
