import 'package:flutter/material.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/models/allMusicAllSongsModel.dart';
import 'package:rally/pages/modules/artists/allArtists/allArtists.dart';
import 'package:rally/pages/modules/library/recentlyPlayed/homeRecentlyPlayed/homeRecentlyPlayed.dart';
import 'package:rally/pages/modules/music/album/allTopAlbums/allTopAlbums.dart';
import 'package:rally/pages/modules/music/homeHeadlines/homeMusicHeadlines.dart';
// import 'package:rally/pages/modules/music/musicVideo/allMusicVideos/allMusicVideos.dart';
import 'package:rally/pages/modules/music/newMusic/newMusic.dart';
import 'package:rally/pages/modules/music/songs/allSongs/allSongs.dart';
import 'package:rally/pages/modules/music/todaysHits/todaysHits.dart';
import 'package:rally/pages/modules/music/topPicks/topPicksMusic.dart';
import 'package:rally/pages/modules/music/trendingMusic/trendingMusic.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget musicWidget({
  @required AllMusicAllSongsModel? allMusicAllSongsModel,
  @required void Function(String genre)? onGenre,
  @required String? genreDisplay,
  @required Stream<String>? selectedGenreStream,
}) {
  List<String> allGenreList = [];
  if (allMusicAllSongsModel != null) {
    for (var data in allMusicAllSongsModel.data!) {
      for (var genre in data.genres!) allGenreList.add(genre.genre!.name!);
    }
  }

  List<String> distinctGenreList = allGenreList.toSet().toList();

  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeRecentlyPlayed(),
        HomeMusicHeadlines(),
        SizedBox(height: 20),
        if (allMusicAllSongsModel == null) shimmerItem(numOfItem: 1),
        if (allMusicAllSongsModel != null)
          Container(
            height: 30,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: distinctGenreList.length + 1,
              separatorBuilder: (_, int index) => SizedBox(width: 5),
              itemBuilder: (BuildContext context, int index) => index == 0
                  ? GestureDetector(
                      onTap: () => onGenre!("all"),
                      child: Chip(
                        label: Text("All"),
                        labelStyle: h5White,
                        backgroundColor:
                            genreDisplay == "all" ? PRIMARYCOLOR : PRIMARYCOLOR1,
                      ),
                    )
                  : GestureDetector(
                      onTap: () => onGenre!(distinctGenreList[index - 1]),
                      child: Chip(
                        label: Text("${distinctGenreList[index - 1]}"),
                        labelStyle: h5White,
                        backgroundColor:
                            genreDisplay == distinctGenreList[index - 1]
                                ? PRIMARYCOLOR
                                : PRIMARYCOLOR1,
                      ),
                    ),
            ),
          ),
        SizedBox(height: 10),
        StreamBuilder(
          stream: selectedGenreStream,
          initialData: "all",
          builder: (context, snapshot) {
            final genreData = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NewMusic(
                  allMusicModel: allMusicAllSongsModel,
                  selectedGenre: genreData.toString(),
                ),
                SizedBox(height: 10),
                TrendingMusic(
                  allMusicModel: allMusicAllSongsModel,
                  selectedGenre: genreData.toString(),
                ),
                SizedBox(height: 10),
                AllArtists(),
                SizedBox(height: 30),
                TodaysHits(
                  allMusicModel: allMusicAllSongsModel,
                  selectedGenre: genreData.toString(),
                ),
                SizedBox(height: 10),
                AllTopAlbums(),
                SizedBox(height: 10),
                AllArtists(showNextSet: true),
                // AllMusicVideos(),
                SizedBox(height: 30),
                TopPicksMusic(
                  allMusicModel: allMusicAllSongsModel,
                  selectedGenre: genreData.toString(),
                ),
                SizedBox(height: 10),
                if (allMusicAllSongsModel == null) shimmerItem(useGrid: true),
                if (allMusicAllSongsModel != null)
                  AllSongs(
                    allMusicModel: allMusicAllSongsModel,
                    selectedGenre: genreData.toString(),
                  ),
              ],
            );
          },
        ),
        SizedBox(height: 80),
      ],
    ),
  );
}
