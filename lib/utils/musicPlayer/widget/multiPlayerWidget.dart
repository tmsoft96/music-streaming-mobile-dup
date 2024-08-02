import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget multiPlayerWidget({
  @required BuildContext? context,
  @required void Function()? onSinglePlayer,
  @required AudioPlayer? player,
  @required ConcatenatingAudioSource? playlist,
  @required void Function()? onArtist,
}) {
  return Stack(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(top: 60),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: StreamBuilder<SequenceState?>(
                      stream: player!.sequenceStateStream,
                      builder: (context, snapshot) {
                        final state = snapshot.data;
                        if (state?.sequence.isEmpty ?? true) {
                          return const SizedBox();
                        }
                        final metadata = state!.currentSource!.tag as MediaItem;
                        return !metadata.extras!["isCoverLocal"]!
                            ? cachedImage(
                                context: context,
                                image: metadata.artUri.toString(),
                                height: 80,
                                width: 80,
                                placeholder: NOAUDIOCOVER,
                              )
                            : Image.file(
                                File(metadata.artUri.toString()),
                                height: 80,
                                width: 80,
                              );
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: MediaQuery.of(context!).size.width - 110,
                    child: StreamBuilder<SequenceState?>(
                      stream: player.sequenceStateStream,
                      builder: (context, snapshot) {
                        final state = snapshot.data;
                        if (state?.sequence.isEmpty ?? true) {
                          return const SizedBox();
                        }
                        final metadata = state!.currentSource!.tag as MediaItem;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${metadata.title}", style: h5WhiteBold),
                            SizedBox(height: 3),
                            button(
                              onPressed: onArtist,
                              text: "${metadata.artist}  >",
                              textColor: BLACK,
                              color: TRANSPARENT,
                              context: context,
                              useWidth: false,
                              textStyle: h6White,
                              padding: EdgeInsets.zero,
                              height: 30,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<SequenceState?>(
                    stream: player.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      final sequence = state?.sequence ?? [];
                      return Text(
                        "Queue  (${sequence.length} songs)",
                        style: h6WhiteBold,
                      );
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: onSinglePlayer,
                        icon: Icon(FeatherIcons.list),
                        iconSize: 35,
                        color: PRIMARYCOLOR,
                      ),
                      SizedBox(width: 10),
                      StreamBuilder<bool>(
                        stream: player.shuffleModeEnabledStream,
                        builder: (context, snapshot) {
                          final shuffleModeEnabled = snapshot.data ?? false;
                          return IconButton(
                            icon: shuffleModeEnabled
                                ? const Icon(
                                    Icons.shuffle,
                                    color: PRIMARYCOLOR,
                                  )
                                : const Icon(Icons.shuffle, color: BLACK),
                            onPressed: () async {
                              final enable = !shuffleModeEnabled;
                              if (enable) {
                                await player.shuffle();
                              }
                              await player.setShuffleModeEnabled(enable);
                            },
                          );
                        },
                      ),
                      SizedBox(width: 10),
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
                ],
              ),
            ],
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 220),
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height - 420,
        child: StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) {
            final state = snapshot.data;
            final sequence = state?.sequence ?? [];
            return ReorderableListView(
              onReorder: (int oldIndex, int newIndex) {
                if (oldIndex < newIndex) newIndex--;
                playlist!.move(oldIndex, newIndex);
              },
              children: [
                for (var i = 0; i < sequence.length; i++)
                  Dismissible(
                    key: ValueKey(sequence[i]),
                    background: Container(
                      color: RED,
                      alignment: Alignment.centerRight,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.delete, color: BLACK),
                      ),
                    ),
                    onDismissed: (dismissDirection) {
                      playlist!.removeAt(i);
                    },
                    child: Material(
                      color: i == state!.currentIndex
                          ? PRIMARYCOLOR.withOpacity(.3)
                          : TRANSPARENT,
                      borderRadius: BorderRadius.circular(20),
                      child: ListTile(
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            i == state.currentIndex
                                ? Image.asset(
                                    LISTENING,
                                    height: 40,
                                    width: 10,
                                    fit: BoxFit.fill,
                                  )
                                : Text(
                                    "${i + 1}.",
                                    style: h6WhiteBold,
                                  ),
                            // SizedBox(width: 10),
                            // ClipRRect(
                            //   borderRadius: BorderRadius.circular(10),
                            //   child: Container(
                            //     color: WHITE,
                            //     child: !sequence[i].tag.extras!["isCoverLocal"]!
                            //         ? cachedImage(
                            //             context: context,
                            //             image:
                            //                 sequence[i].tag.artUri.toString(),
                            //             height: 50,
                            //             width: 50,
                            //             placeholder: NOAUDIOCOVER,
                            //           )
                            //         : Image.file(
                            //             File(sequence[i].tag.artUri.toString()),
                            //             height: 50,
                            //             width: 50,
                            //           ),
                            //   ),
                            // ),
                          ],
                        ),
                        title: Text(
                          sequence[i].tag.title as String,
                          style: h6WhiteBold,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        subtitle: Text(
                          sequence[i].tag.artist as String,
                          style: h7White,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: sequence[i].duration != null
                            ? Text(
                                RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                        .firstMatch("${sequence[i].duration}")
                                        ?.group(1) ??
                                    '${sequence[i].duration}',
                                style: h6WhiteBold,
                              )
                            : null,
                        onTap: () => player.seek(Duration.zero, index: i),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    ],
  );
}
