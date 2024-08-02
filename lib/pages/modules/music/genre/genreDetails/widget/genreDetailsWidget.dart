import 'package:flutter/material.dart';
import 'package:rally/models/allMusicAllSongsModel.dart';
import 'package:rally/pages/modules/artists/allArtists/allArtists.dart';
import 'package:rally/pages/modules/music/newMusic/newMusic.dart';
import 'package:rally/pages/modules/music/songs/allSongs/allSongs.dart';
import 'package:rally/pages/modules/music/todaysHits/todaysHits.dart';
import 'package:rally/pages/modules/music/trendingMusic/trendingMusic.dart';

Widget genreDetailsWidget({
  @required BuildContext? context,
  @required AllMusicAllSongsModel? model,
  @required String? genre,
}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        NewMusic(allMusicModel: model!, selectedGenre: genre),
        SizedBox(height: 10),
        TrendingMusic(allMusicModel: model, selectedGenre: genre),
        SizedBox(height: 10),
        TodaysHits(allMusicModel: model, selectedGenre: genre),
        AllArtists(),
        SizedBox(height: 10),
        AllSongs(allMusicModel: model, selectedGenre: genre),
        SizedBox(height: 20),
      ],
    ),
  );
}
