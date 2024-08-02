import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rally/components/loadingView.dart';
import 'package:rally/spec/colors.dart';

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<double>(
                stream: player.volumeStream,
                builder: (context, snapshot) {
                  double volume = snapshot.data ?? 1;
                  return IconButton(
                    icon: Icon(
                      volume == 0 ? Icons.volume_off : Icons.volume_up,
                    ),
                    color: BLACK,
                    onPressed: () {
                      // showSliderDialog(
                      //   context: context,
                      //   title: "Adjust volume",
                      //   divisions: 10,
                      //   min: 0.0,
                      //   max: 1.0,
                      //   stream: player.volumeStream,
                      //   onChanged: player.setVolume,
                      // );

                      player.setVolume(volume == 0 ? 1 : 0);
                    },
                  );
                }),

            StreamBuilder<SequenceState?>(
              stream: player.sequenceStateStream,
              builder: (context, snapshot) => IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: player.hasPrevious ? player.seekToPrevious : null,
                iconSize: 50,
                color: BLACK,
              ),
            ),
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                print("player state ${processingState.toString()}");
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 100,
                    height: 100,
                    child: loadingFadingCircle(PRIMARYCOLOR, size: 100),
                  );
                } else if (playing != true) {
                  return IconButton(
                    icon: const Icon(Icons.play_arrow_rounded),
                    onPressed: player.play,
                    iconSize: 100,
                    color: BLACK,
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    icon: const Icon(Icons.pause),
                    iconSize: 100,
                    color: BLACK,
                    onPressed: player.pause,
                  );
                } else {
                  return IconButton(
                    icon: const Icon(Icons.replay),
                    iconSize: 100,
                    color: BLACK,
                    onPressed: () => player.seek(Duration.zero,
                        index: player.effectiveIndices!.first),
                  );
                }
              },
            ),
            StreamBuilder<SequenceState?>(
              stream: player.sequenceStateStream,
              builder: (context, snapshot) => IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: player.hasNext ? player.seekToNext : null,
                iconSize: 50,
                color: BLACK,
              ),
            ),
            // StreamBuilder<double>(
            //   stream: player.speedStream,
            //   builder: (context, snapshot) => IconButton(
            //     icon: Text(
            //       "${snapshot.data?.toStringAsFixed(1)}x",
            //       style: h6White,
            //     ),
            //     onPressed: () {
            //       showSliderDialog(
            //         context: context,
            //         title: "Adjust speed",
            //         divisions: 10,
            //         min: 0.5,
            //         max: 1.5,
            //         stream: player.speedStream,
            //         onChanged: player.setSpeed,
            //       );
            //     },
            //   ),
            // ),
            StreamBuilder<LoopMode>(
              stream: player.loopModeStream,
              builder: (context, snapshot) {
                final loopMode = snapshot.data ?? LoopMode.off;
                const icons = [
                  Icon(Icons.repeat, color: BLACK),
                  Icon(Icons.repeat, color: PRIMARYCOLOR),
                  Icon(Icons.repeat_one_rounded, color: PRIMARYCOLOR),
                ];
                const cycleModes = [
                  LoopMode.off,
                  LoopMode.all,
                  LoopMode.one,
                ];
                final index = cycleModes.indexOf(loopMode);
                return IconButton(
                  icon: icons[index],
                  onPressed: () {
                    player.setLoopMode(cycleModes[
                        (cycleModes.indexOf(loopMode) + 1) %
                            cycleModes.length]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
