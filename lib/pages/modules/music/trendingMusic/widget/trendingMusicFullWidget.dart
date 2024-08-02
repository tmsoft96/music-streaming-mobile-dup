import 'package:flutter/material.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/models/allMusicAllSongsModel.dart';
import 'package:rally/models/allMusicTrendingModel.dart';
import 'package:rally/components/contentDisplayFull.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget trendingMusicFullWidget({
  @required BuildContext? context,
  @required void Function(MusicData data)? onMusic,
  @required AllMusicTrendingModel? model,
  @required String? selectedGenre,
  @required AllMusicAllSongsModel? allMusicModel,
  @required void Function(String genre)? onGenre,
  @required void Function(MusicData data)? onMusicMore,
  @required void Function(MusicData data)? onMusicPlay,
  @required
      Future<PaginatedItemsResponse<MusicData>?> Function(bool)? fetchPageData,
  @required PaginatedItemsResponse<MusicData>? response,
}) {
  bool isShow = false;
  for (int x = 0; x < model!.data!.length; ++x)
    if (!model.data![x].filepath!.split("/").last.contains("mp4")) {
      isShow = true;
      break;
    }

  List<String> allGenreList = [];
  if (allMusicModel != null) {
    for (var data in allMusicModel.data!) {
      for (var genre in data.genres!) allGenreList.add(genre.genre!.name!);
    }
  }

  List<String> distinctGenreList = allGenreList.toSet().toList();

  return isShow
      ? Stack(
          children: [
            if (allMusicModel == null) shimmerItem(numOfItem: 1),
            if (allMusicModel != null)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => onGenre!("all"),
                      child: Chip(
                        label: Text("All"),
                        labelStyle: h5White,
                        backgroundColor: selectedGenre == "all"
                            ? PRIMARYCOLOR
                            : PRIMARYCOLOR1,
                      ),
                    ),
                    SizedBox(width: 5),
                    for (String genre in distinctGenreList) ...[
                      GestureDetector(
                        onTap: () => onGenre!(genre),
                        child: Chip(
                          label: Text("$genre"),
                          labelStyle: h5White,
                          backgroundColor: selectedGenre == genre
                              ? PRIMARYCOLOR
                              : PRIMARYCOLOR1,
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                    SizedBox(width: 10),
                  ],
                ),
              ),
            Container(
              margin: EdgeInsets.only(top: 50),
              child: PaginatedItemsBuilder<MusicData>(
                response: response!,
                fetchPageData: (bool reset) => fetchPageData!(reset),
                itemBuilder: (BuildContext context, int index, item) {
                  bool show = selectedGenre!.toLowerCase() == "all";
                  if (selectedGenre.toLowerCase() != "all")
                    for (var genre in item.genres!) {
                      if (genre.genre!.name! == selectedGenre) {
                        show = true;
                        break;
                      }
                    }

                  return !item.filepath!.split("/").last.contains("mp4") && show
                      ? contentDisplayFull(
                          context: context,
                          image: item.media!.thumb,
                          streamNumber: item.streams!.length,
                          title: item.title,
                          artistName: item.stageName,
                          onContent: () => onMusic!(item),
                          onContentMore: () => onMusicMore!(item),
                          onContentPlay: () => onMusicPlay!(item),
                        )
                      : SizedBox();
                },
                loaderItemsCount: 20,
              ),
            ),
          ],
        )
      : emptyBox(context!, msg: "No data available");
}
