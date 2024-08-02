import 'package:flutter/material.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/pages/modules/radio/topRadioShow/topPodcastShow.dart';
import 'package:rally/pages/modules/radio/upcomingBroadcast/upcomingBroadcast.dart';
import 'package:rally/spec/styles.dart';

Widget searchRadioNoTextWdget({
  @required BuildContext? context,
  @required void Function(String name)? onTag,
  @required AllPodcastModel? model,
  @required String? searchText,
}) {
  List<String> stageNameList = [];
  for (var data in model!.data!) stageNameList.add(data.stageName!);

  List<String> distinctList = stageNameList.toSet().toList();

  int maxNum = distinctList.length > 15 ? 15 : distinctList.length;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text("Top creators", style: h5WhiteBold),
      ),
      SizedBox(height: 10),
      if (model.data!.length == 0)
        emptyBoxLinear(context!, msg: "No creator available"),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Wrap(
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
      UpcomingBroadcast(),
      SizedBox(height: 10),
      TopPodcastShow(),
      SizedBox(height: 10),
    ],
  );
}
