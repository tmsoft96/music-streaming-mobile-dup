import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/contentDisplayHome1.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/models/allAlbumHomepageModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget allTopAlbumsWidget({
  @required BuildContext? context,
  @required void Function()? onSeeAll,
  @required void Function(AllAlbumHomepageData data)? onAlbum,
  @required void Function(AllAlbumHomepageData data)? onAlbumMore,
  @required void Function(AllAlbumHomepageData data)? onPlayAlbum,
  @required AllAlbumHomepageModel? model,
}) {
  List<int> displayNoList = [];
  for (int x = 0; x < model!.data!.length; ++x) {
    if (model.data![x].files!.length > 0) {
      displayNoList += [x];
      if (displayNoList.length == 10) break;
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
            Text("Top Albums", style: h4White),
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
        emptyBoxLinear(context!, msg: "No album available"),
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
              onContent: () => onAlbum!(model.data![displayNoList[index]]),
              onContentMore: () =>
                  onAlbumMore!(model.data![displayNoList[index]]),
              streamNumber: null,
              title: "${model.data![displayNoList[index]].name}",
              stageName: "${model.data![displayNoList[index]].stageName}",
              onPlayContent: () =>
                  onPlayAlbum!(model.data![displayNoList[index]]),
            ),
          ),
        ),
    ],
  );
}
