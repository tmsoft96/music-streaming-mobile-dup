import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/spec/styles.dart';

Widget lyricsWidget({
  @required BuildContext? context,
  @required AudioPlayer? player,
  @required PlayerModel? playerModel,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    margin: EdgeInsets.only(top: 60),
    width: double.maxFinite,
    height: MediaQuery.of(context!).size.height - 280,
    alignment: Alignment.center,
    child: StreamBuilder<SequenceState?>(
      stream: player!.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox();
        }
        final metadata = state!.currentSource!.tag as MediaItem;
        String? ly = playerModel!.data![int.parse(metadata.id)].lyrics;
        return SingleChildScrollView(
          child: Text(
            "${ly == "" || ly == null ? 'Lyrics not available,\nget it yourself' : ly}",
            style: ly == "" || ly == null ? h3WhiteBold : h5WhiteBold,
            textAlign: TextAlign.center,
          ),
        );
      },
    ),
  );
}
