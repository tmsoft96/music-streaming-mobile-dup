import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/contentDisplayHome2.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/models/allMusicTrendingModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget trendingMusicWidget({
  @required BuildContext? context,
  @required void Function()? onSeeAll,
  @required void Function(MusicData data)? onSong,
  @required void Function(MusicData data)? onSongPlay,
  @required void Function(MusicData data)? onSongMore,
  @required AllMusicTrendingModel? model,
  @required String? selectedGenre,
}) {
  List<int> displayNoList = [];

  for (int x = 0; x < model!.data!.length; ++x) {
    if (!model.data![x].filepath!.split("/").last.contains("mp4")) {
      if (selectedGenre!.toLowerCase() == "all") displayNoList += [x];
      if (selectedGenre.toLowerCase() != "all")
        for (var genre in model.data![x].genres!)
          if (genre.genre!.name! == selectedGenre) displayNoList += [x];

      if (displayNoList.length == 12) break;
    }
  }

  List<MusicData> list1 = [];
  List<MusicData> list2 = [];
  List<MusicData> list3 = [];
  List<MusicData> list4 = [];

  int ins = 0;

  for (int x = 0; x < displayNoList.length; ++x) {
    if (ins == 0) {
      list1 += [model.data![displayNoList[x]]];
      ++ins;
    } else if (ins == 1) {
      list2 += [model.data![displayNoList[x]]];
      ++ins;
    } else if (ins == 2) {
      list3 += [model.data![displayNoList[x]]];
      ++ins;
    } else if (ins == 3) {
      list4 += [model.data![displayNoList[x]]];
      ins = 0;
    }
  }

  List<int> maxLength = [
    list1.length,
    list2.length,
    list3.length,
    list4.length,
  ];

  maxLength.sort((a, b) => b.compareTo(a));

  print(maxLength);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Trending Songs", style: h4White),
                SizedBox(height: 5),
                Text(
                  "Most played songs in the region.",
                  style: h7White,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          button(
            onPressed: onSeeAll,
            text: 'More >',
            color: BACKGROUND,
            context: context,
            useWidth: false,
            textColor: PRIMARYCOLOR,
          ),
        ],
      ),
      if (model.data!.length == 0)
        emptyBoxLinear(context!, msg: "No data available"),
      if (model.data!.length > 0)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: 15),
              Column(
                children: [
                  Row(
                    children: [
                      for (var data in list1) ...[
                        _layout(
                          context: context,
                          allMusicData: data,
                          onContent: () => onSong!(data),
                          onContentMore: () => onSongMore!(data),
                          onPlayContent: () => onSongPlay!(data),
                        ),
                        SizedBox(width: 5),
                      ],
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      for (int x = 0; x < list2.length; ++x) ...[
                        _layout(
                          context: context,
                          allMusicData: list2[x],
                          onContent: () => onSong!(list2[x]),
                          onContentMore: () => onSongMore!(list2[x]),
                          onPlayContent: () => onSongPlay!(list2[x]),
                        ),
                        SizedBox(width: 5),
                        if (list2.length - 1 == x &&
                            list2.length < maxLength[0])
                          Container(
                              width: MediaQuery.of(context!).size.width * .8),
                      ],
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      for (int x = 0; x < list3.length; ++x) ...[
                        _layout(
                          context: context,
                          allMusicData: list3[x],
                          onContent: () => onSong!(list3[x]),
                          onContentMore: () => onSongMore!(list3[x]),
                          onPlayContent: () => onSongPlay!(list3[x]),
                        ),
                        SizedBox(width: 5),
                        if (list3.length - 1 == x &&
                            list3.length < maxLength[0])
                          Container(
                              width: MediaQuery.of(context!).size.width * .8),
                      ],
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      for (int x = 0; x < list4.length; ++x) ...[
                        _layout(
                          context: context,
                          allMusicData: list4[x],
                          onContent: () => onSong!(list4[x]),
                          onContentMore: () => onSongMore!(list4[x]),
                          onPlayContent: () => onSongPlay!(list4[x]),
                        ),
                        SizedBox(width: 5),
                        if (list4.length - 1 == x &&
                            list4.length < maxLength[0])
                          Container(
                              width: MediaQuery.of(context!).size.width * .8),
                      ],
                    ],
                  ),
                  SizedBox(width: 15),
                ],
              ),
              SizedBox(width: 15),
            ],
          ),
        ),
    ],
  );
}

Widget _layout({
  @required BuildContext? context,
  @required MusicData? allMusicData,
  @required void Function()? onContentMore,
  @required void Function()? onContent,
  @required void Function()? onPlayContent,
}) {
  return contentDisplayHome2(
    context: context,
    contentImage: allMusicData!.media!.thumb,
    title: "${allMusicData.title}",
    artistName:
        "${allMusicData.stageName == null ? allMusicData.user!.name : allMusicData.stageName}",
    streamNumber: allMusicData.streams!.length,
    onContent: onContent,
    onContentMore: onContentMore,
    onPlayContent: onPlayContent,
  );
}
