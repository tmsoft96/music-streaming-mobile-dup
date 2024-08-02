import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/contentDisplayHome1.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allMusicAllSongsModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget allSongsWidget({
  @required BuildContext? context,
  @required void Function()? onSeeAll,
  @required AllMusicAllSongsModel? model,
  @required void Function(MusicAllSongsData data)? onTrackMore,
  @required void Function(MusicAllSongsData data)? onMusic,
  @required void Function(MusicAllSongsData data)? onPlayTrack,
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

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text("All Songs", style: h4White),
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
      if (model.data!.length == 0) shimmerItem(useGrid: true),
      if (model.data!.length > 0)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: displayNoList.length,
            separatorBuilder: (_, int index) => SizedBox(width: 10),
            itemBuilder: (BuildContext context, int index) =>
                contentDisplayHome1(
              context: context,
              contentImage: model.data![displayNoList[index]].media!.thumb,
              onContent: () => onMusic!(model.data![displayNoList[index]]),
              onContentMore: () =>
                  onTrackMore!(model.data![displayNoList[index]]),
              streamNumber:
                  "${getNumberFormat(model.data![displayNoList[index]].streams!.length)}",
              title: "${model.data![displayNoList[index]].title}",
              stageName: "${model.data![displayNoList[index]].stageName}",
              onPlayContent: () =>
                  onPlayTrack!(model.data![displayNoList[index]]),
            ),
          ),
        ),
    ],
  );
}
