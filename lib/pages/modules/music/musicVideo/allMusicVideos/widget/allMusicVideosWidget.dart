import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/contentDisplayHome1.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget allMusicVideosWidget({
  @required BuildContext? context,
  @required void Function()? onSeeAll,
  @required AllMusicModel? model,
  @required void Function(AllMusicData data)? onMusic,
  @required void Function(AllMusicData data)? onTrackMore,
  @required void Function(AllMusicData data)? onPlayTrack,
}) {
  List<int> displayNoList = [];

  for (int x = 0; x < model!.data!.length; ++x) {
    if (model.data![x].filepath!.split("/").last.contains("mp4")) {
      displayNoList += [x];
      if (displayNoList.length == 15) break;
    }
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Music Videos", style: h4White),
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
      ),
      if (displayNoList.length == 0)
        emptyBoxLinear(
          context!,
          msg: "No music video available",
        ),
      if (displayNoList.length > 0)
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
