import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/contentDisplayHome2.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget morePodcastWidget({
  @required BuildContext? context,
  @required void Function()? onSeeAll,
  @required void Function(AllRadioData data)? onBroadcast,
  @required void Function(AllRadioData data)? onBroadcastMore,
  @required void Function(AllRadioData data)? onBroadcastPlay,
  @required AllPodcastModel? model,
}) {
  List<int> displayNoList = [];

  for (int x = 0; x < model!.data!.length; ++x) {
    displayNoList += [x];
    if (displayNoList.length == 15) break;
  }

  List<AllRadioData> list1 = [];
  List<AllRadioData> list2 = [];
  List<AllRadioData> list3 = [];
  List<AllRadioData> list4 = [];

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

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("More Podcast", style: h4White),
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
        emptyBoxLinear(context!, msg: "No data available"),
      if (model.data!.length > 0)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      for (var data in list1) ...[
                         _layout(
                          context: context,
                          data: data,
                          onBroadcast: () => onBroadcast!(data),
                          onBroadcastMore: () => onBroadcastMore!(data),
                          onBroadcastPlay: () => onBroadcastPlay!(data),
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
                          data: list2[x],
                          onBroadcast: () => onBroadcast!(list2[x]),
                          onBroadcastMore: () => onBroadcastMore!(list2[x]),
                          onBroadcastPlay: () => onBroadcastPlay!(list2[x]),
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
                          data: list3[x],
                          onBroadcast: () => onBroadcast!(list3[x]),
                          onBroadcastMore: () => onBroadcastMore!(list3[x]),
                          onBroadcastPlay: () => onBroadcastPlay!(list3[x]),
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
                          data: list4[x],
                          onBroadcast: () => onBroadcast!(list4[x]),
                          onBroadcastMore: () => onBroadcastMore!(list4[x]),
                          onBroadcastPlay: () => onBroadcastPlay!(list4[x]),
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
  @required AllRadioData? data,
  @required void Function()? onBroadcast,
  @required void Function()? onBroadcastMore,
  @required void Function()? onBroadcastPlay,
}) {
  return contentDisplayHome2(
    context: context,
    contentImage: data!.cover,
    title: "${data.title}",
    artistName:
        "${data.stageName == null ? data.user!.name : data.stageName}",
    streamNumber: data.streams!.length,
    onContent: onBroadcast,
    onContentMore: onBroadcastMore,
    onPlayContent: onBroadcastPlay,
  );
}
