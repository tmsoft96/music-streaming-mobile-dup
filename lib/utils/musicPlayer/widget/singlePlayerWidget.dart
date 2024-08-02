import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget singlePlayerWidget({
  @required BuildContext? context,
  @required void Function()? onDownload,
  @required void Function()? onMultiPlayer,
  @required bool? isRadio,
  @required AudioPlayer? player,
  @required void Function()? onPlaylistAdd,
  @required void Function()? onComment,
  @required void Function()? onFavorite,
  @required void Function()? onArtist,
  @required PlayerModel? playerModel,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    margin: EdgeInsets.only(top: 60),
    width: double.maxFinite,
    height: MediaQuery.of(context!).size.height - 260,
    child: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
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
                          image:
                              playerModel!.data![int.parse(metadata.id)].cover,
                          height: MediaQuery.of(context).size.height * .37,
                          width: MediaQuery.of(context).size.width * .75,
                          placeholder: NOAUDIOCOVER,
                          diskCache: null,
                        )
                      : Image.file(
                          File(
                            playerModel!.data![int.parse(metadata.id)].cover!,
                          ),
                          height: MediaQuery.of(context).size.height * .37,
                          width: MediaQuery.of(context).size.width * .75,
                        );
                },
              ),
            ),
            SizedBox(height: 20),
            StreamBuilder<SequenceState?>(
              stream: player.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox();
                }
                final metadata = state!.currentSource!.tag as MediaItem;
                final span = TextSpan(
                  text: metadata.title,
                  style: h4WhiteBold,
                );
                final tp = TextPainter(
                  text: span,
                  maxLines: 1,
                  textDirection: TextDirection.ltr,
                );
                tp.layout(
                  maxWidth: MediaQuery.of(context).size.width - 30,
                );
                print("maxLine ${tp.didExceedMaxLines}");
                return Column(
                  children: [
                    tp.didExceedMaxLines
                        ? Container(
                            height: 30,
                            width: double.maxFinite,
                            child: Marquee(
                              text: "${metadata.title}",
                              style: h4WhiteBold,
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              blankSpace: 20.0,
                              velocity: 100.0,
                              pauseAfterRound: Duration(seconds: 2),
                              startPadding: 10.0,
                              accelerationDuration: Duration(seconds: 2),
                              accelerationCurve: Curves.linear,
                              decelerationDuration: Duration(milliseconds: 500),
                              decelerationCurve: Curves.easeOut,
                            ),
                          )
                        : Text(
                            "${metadata.title}",
                            style: h4WhiteBold,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                    button(
                      onPressed: onArtist,
                      text: "${metadata.artist}  >",
                      color: TRANSPARENT,
                      textColor: BLACK,
                      context: context,
                      useWidth: false,
                      textStyle: h6White,
                      padding: EdgeInsets.zero,
                      height: 30,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (onDownload != null &&
                            !metadata.extras!["isFileLocal"])
                          button(
                            onPressed: onDownload,
                            text: "Download",
                            textColor: BLACK,
                            color: TRANSPARENT,
                            context: context,
                            divideWidth: .18,
                            textStyle: h7White,
                            icon: Icon(FeatherIcons.download, color: BLACK),
                            useColumnIconType: true,
                            useFittedText: true,
                          ),
                        button(
                          onPressed: onFavorite,
                          text: "Favourite",
                          color: TRANSPARENT,
                          context: context,
                          textColor: BLACK,
                          divideWidth: .18,
                          textStyle: h7White,
                          icon: StreamBuilder(
                            stream: favoriteContentModelStream,
                            initialData: favoriteContentModel ?? null,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                // FavoriteContentModel model = snapshot.data;
                                String contentId = playerModel!
                                    .data![int.parse(metadata.id)].id!;
                                return Icon(
                                  checkContentFavorite(
                                    contentId: contentId,
                                    type: "single",
                                  )
                                      ? Icons.favorite
                                      : FeatherIcons.heart,
                                  color: checkContentFavorite(
                                    contentId: contentId,
                                    type: "single",
                                  )
                                      ? PRIMARYCOLOR
                                      : BLACK,
                                );
                              }
                              return Icon(FeatherIcons.heart, color: BLACK);
                            },
                          ),
                          useColumnIconType: true,
                          useFittedText: true,
                        ),
                        button(
                          onPressed: onComment,
                          text: "Comment",
                          color: TRANSPARENT,
                          textColor: BLACK,
                          context: context,
                          divideWidth: .18,
                          textStyle: h7White,
                          icon: Icon(FeatherIcons.messageSquare, color: BLACK),
                          useColumnIconType: true,
                          useFittedText: true,
                        ),
                        StreamBuilder<SequenceState?>(
                          stream: player.sequenceStateStream,
                          builder: (context, snapshot) {
                            final state = snapshot.data;
                            if (state?.sequence.isEmpty ?? true) {
                              return const SizedBox();
                            }
                            final metadata =
                                state!.currentSource!.tag as MediaItem;

                            return onPlaylistAdd != null &&
                                    !metadata.extras!["isFileLocal"]
                                ? button(
                                    onPressed: onPlaylistAdd,
                                    text: "Playlist",
                                    color: TRANSPARENT,
                                    textColor: BLACK,
                                    context: context,
                                    divideWidth: .18,
                                    textStyle: h7White,
                                    icon: Icon(Icons.playlist_add, color: BLACK),
                                    useColumnIconType: true,
                                    useFittedText: true,
                                  )
                                : SizedBox();
                          },
                        ),
                        button(
                          onPressed: onMultiPlayer,
                          text: "Queue",
                          color: TRANSPARENT,
                          context: context,
                          textColor: BLACK,
                          divideWidth: .18,
                          textStyle: h7White,
                          icon: Icon(FeatherIcons.list, color: BLACK),
                          useColumnIconType: true,
                          useFittedText: true,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
