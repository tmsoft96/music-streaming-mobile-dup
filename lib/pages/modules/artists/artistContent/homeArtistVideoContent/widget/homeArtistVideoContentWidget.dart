import 'package:flutter/material.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/components/contentDisplayFull.dart';

Widget homeArtistVideoContentWidget({
  @required BuildContext? context,
  @required int? noOfContentDisplay,
  @required void Function(AllMusicData data)? onContent,
  @required void Function(AllMusicData data)? onContentMore,
  @required void Function(AllMusicData data)? onContentPlay,
  @required AllMusicModel? model,
}) {
  List<int> displayNoList = [];

  for (int x = 0; x < model!.data!.length; ++x) {
    if (model.data![x].filepath!.split("/").last.contains("mp4")) {
      displayNoList += [x];
      if (displayNoList.length == 5) break;
    }
  }

  return Column(
    children: [
      if (displayNoList.length == 0)
        noOfContentDisplay == -1000
            ? emptyBox(context!, msg: "No video content available")
            : emptyBoxLinear(context!, msg: "No video content available"),
      if (noOfContentDisplay != null &&
          displayNoList.length > 0 &&
          noOfContentDisplay != -1000)
        contentDisplayFull(
          context: context,
          image: model.data![displayNoList[0]].media!.thumb,
          streamNumber: model.data![displayNoList[0]].streams!.length,
          title: model.data![displayNoList[0]].title,
          onContent: () => onContent!(model.data![displayNoList[0]]),
          onContentMore: () => onContentMore!(model.data![displayNoList[0]]),
          onContentPlay: () => onContentPlay!(model.data![displayNoList[0]]),
          artistName: model.data![displayNoList[0]].stageName,
        ),
      if (noOfContentDisplay == null)
        for (int x = 0; x < displayNoList.length; ++x)
          contentDisplayFull(
            context: context,
            image: model.data![displayNoList[x]].media!.thumb,
            streamNumber: model.data![displayNoList[x]].streams!.length,
            title: model.data![displayNoList[x]].title,
            onContentMore: () => onContentMore!(model.data![displayNoList[0]]),
            onContentPlay: () => onContentPlay!(model.data![displayNoList[0]]),
            artistName: model.data![displayNoList[0]].stageName,
            onContent: () => onContent!(model.data![displayNoList[0]]),
          ),
      if (noOfContentDisplay == -1000)
        for (int x = 0; x < model.data!.length; ++x)
          if (model.data![x].filepath!.split("/").last.contains("mp4"))
            contentDisplayFull(
              context: context,
              image: model.data![x].media!.thumb,
              streamNumber: model.data![x].streams!.length,
              title: model.data![x].title,
              onContent: () => onContent!(model.data![displayNoList[0]]),
              onContentMore: () =>
                  onContentMore!(model.data![displayNoList[0]]),
              onContentPlay: () =>
                  onContentPlay!(model.data![displayNoList[0]]),
              artistName: model.data![displayNoList[0]].stageName,
            ),
    ],
  );
}
