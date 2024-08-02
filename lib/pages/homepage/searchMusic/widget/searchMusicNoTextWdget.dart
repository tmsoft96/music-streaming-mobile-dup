import 'package:flutter/material.dart';
import 'package:rally/components/genreGridLayout.dart';
import 'package:rally/models/allMusicAllSongsModel.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/pages/modules/artists/allArtists/allArtists.dart';
import 'package:rally/pages/modules/music/album/allTopAlbums/allTopAlbums.dart';
import 'package:rally/pages/modules/music/newMusic/newMusic.dart';
import 'package:rally/spec/styles.dart';

Widget searchMusicNoTextWdget({
  @required BuildContext? content,
  @required void Function(String name)? onTag,
  @required AllMusicModel? model,
  @required void Function(String genre)? onGenre,
}) {
  List<String> stageNameList = [];
  for (var data in model!.data!) stageNameList.add(data.stageName!);

  List<String> distinctList = stageNameList.toSet().toList();

  int maxNum = distinctList.length > 12 ? 12 : distinctList.length;

  List<GenreData> allGenreList = [];
  List<String> allGenreStringList = [];
  for (var data in model.data!) {
    for (var genre in data.genres!) {
      allGenreList.add(genre.genre!);
      allGenreStringList.add(genre.genre!.name!);
    }
  }

  List<String> distinctGenreList = allGenreStringList.toSet().toList();
  List<GenreData> allGenreListNew = [];
  for (String d in distinctGenreList) {
    for (var genres in allGenreList) {
      if (d == genres.name) {
        allGenreListNew.add(genres);
        break;
      }
    }
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text("Recent Search Artists", style: h5WhiteBold),
      ),
      SizedBox(height: 10),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Wrap(
          spacing: 5,
          children: [
            for (int x = 0; x < maxNum; ++x)
              GestureDetector(
                onTap: () => onTag!(distinctList[x]),
                child: Chip(label: Text("${distinctList[x]}")),
              ),
          ],
        ),
      ),
      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text("Top Genres", style: h5WhiteBold),
      ),
      SizedBox(height: 10),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: 10),
            for (var data in allGenreListNew) ...[
              genreGridLayout(
                context: content,
                image: "${data.cover}",
                title: '${data.name}',
                onTap: () => onGenre!(data.name!),
              ),
              SizedBox(width: 10),
            ],
          ],
        ),
      ),
      SizedBox(height: 10),
      NewMusic(
        allMusicModel: AllMusicAllSongsModel.fromJson(
          json: model.toJson(),
          httpMsg: "",
        ),
      ),
      SizedBox(height: 10),
      AllArtists(),
      SizedBox(height: 10),
      AllTopAlbums(),
      SizedBox(height: 10),
    ],
  );
}
