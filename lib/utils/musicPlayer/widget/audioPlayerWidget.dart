import 'dart:io';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';
import 'package:rally/utils/musicPlayer/widget/common.dart';
import 'package:rally/utils/musicPlayer/widget/controlButtons.dart';

import 'lyricsWidget.dart';
import 'multiPlayerWidget.dart';
import 'singlePlayerWidget.dart';

MediaItem? currentMediaItem;

Widget audioPlayerWidget({
  @required BuildContext? context,
  @required void Function()? onSinglePlayer,
  @required void Function()? onDownload,
  @required void Function()? onClose,
  @required void Function()? onPlaylistAdd,
  @required void Function(int displayType)? onDisplayType,
  @required bool? isSinglePlayer,
  @required bool? isRadio,
  @required int? displayType,
  @required AudioPlayer? player,
  @required Stream<PositionData>? positionDataStream,
  @required ConcatenatingAudioSource? playlist,
  @required PlayerModel? playerModel,
  @required void Function()? onComment,
  @required void Function()? onFavorite,
  @required void Function()? onArtist,
}) {
  return Container(
    margin: EdgeInsets.only(top: 10),
    // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      color: BLACK,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    child: Stack(
      children: [
        Blur(
          blur: 20,
          blurColor: BACKGROUND,
          child: StreamBuilder<SequenceState?>(
            stream: player!.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state?.sequence.isEmpty ?? true) {
                return const SizedBox();
              }
              final metadata = state!.currentSource!.tag as MediaItem;

              currentMediaItem = metadata;

              return !metadata.extras!["isCoverLocal"]!
                  ? cachedImage(
                      context: context,
                      image: metadata.artUri.toString(),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      placeholder: NOAUDIOCOVER,
                    )
                  : Image.file(
                      File(metadata.artUri.toString()),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: onClose,
              icon: Icon(Icons.arrow_drop_down_rounded),
              iconSize: 50,
              color: BLACK,
            ),
            Row(
              children: [
                // if (!isRadio!) ...[
                //   button(
                //     onPressed: () => onDisplayType!(1),
                //     text: "Discover",
                //     color: TRANSPARENT,
                //     context: context,
                //     useWidth: false,
                //     textStyle: displayType == 1 ? h4BlackBold : h4Black,
                //     textColor: displayType == 1 ? WHITE : ASHDEEP,
                //   ),
                //   Container(color: WHITE, height: 5, width: 5),
                // ],
                button(
                  onPressed: () => onDisplayType!(2),
                  text: "Music",
                  color: TRANSPARENT,
                  context: context,
                  useWidth: false,
                  textStyle: displayType == 2 ? h4BlackBold : h4Black,
                  textColor: displayType == 2 ? PRIMARYCOLOR : BLACK,
                ),
                Container(color: BLACK, height: 5, width: 5),
                button(
                  onPressed: () => onDisplayType!(3),
                  text: "Lyrics",
                  color: TRANSPARENT,
                  context: context,
                  useWidth: false,
                  textStyle: displayType == 3 ? h4BlackBold : h4Black,
                  textColor: displayType == 3 ? PRIMARYCOLOR : BLACK,
                ),
              ],
            ),
          ],
        ),
        if (displayType == 3)
          lyricsWidget(
            context: context,
            player: player,
            playerModel: playerModel,
          ),
        if (displayType == 2)
          isSinglePlayer!
              ? singlePlayerWidget(
                  context: context,
                  onDownload: onDownload,
                  onMultiPlayer: onSinglePlayer,
                  isRadio: isRadio,
                  player: player,
                  onPlaylistAdd: onPlaylistAdd,
                  onComment: onComment,
                  onFavorite: onFavorite,
                  onArtist: onArtist,
                  playerModel: playerModel,
                )
              : multiPlayerWidget(
                  context: context,
                  onSinglePlayer: onSinglePlayer,
                  player: player,
                  playlist: playlist,
                  onArtist: onArtist,
                ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<PositionData>(
                stream: positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return SeekBar(
                    duration: positionData?.duration ?? Duration.zero,
                    position: positionData?.position ?? Duration.zero,
                    bufferedPosition:
                        positionData?.bufferedPosition ?? Duration.zero,
                    onChangeEnd: (newPosition) => player.seek(newPosition),
                  );
                },
              ),
              ControlButtons(player),
            ],
          ),
        ),
      ],
    ),
  );
}
