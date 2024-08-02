import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/contentDisplayHome1.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget topPodcastShowWidget({
  @required BuildContext? context,
  @required void Function()? onSeeAll,
  @required void Function(AllRadioData data)? onShow,
  @required void Function(AllRadioData data)? onBroadcastMore,
  @required void Function(AllRadioData data)? onBroadcastPlay,
  @required bool? fromAdminPage,
  @required AllPodcastModel? model,
}) {
  List<int> displayNoList = [];

  for (int x = 0; x < model!.data!.length; ++x) {
    displayNoList += [x];
    if (displayNoList.length == 15) break;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: fromAdminPage!
            ? EdgeInsets.zero
            : EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Top Shows", style: h4White),
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
      if (model.data!.length == 0)
        emptyBoxLinear(
          context!,
          msg: "No top shows available",
        ),
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
              contentImage: model.data![displayNoList[index]].cover,
              onContent: () => onShow!(model.data![displayNoList[index]]),
              onContentMore: () =>
                  onBroadcastMore!(model.data![displayNoList[index]]),
              streamNumber:
                  "${getNumberFormat(model.data![displayNoList[index]].streams!.length)}",
              title: "${model.data![displayNoList[index]].title}",
              stageName: "${model.data![displayNoList[index]].stageName}",
              onPlayContent: () =>
                  onBroadcastPlay!(model.data![displayNoList[index]]),
            ),
          ),
        ),
    ],
  );
}
