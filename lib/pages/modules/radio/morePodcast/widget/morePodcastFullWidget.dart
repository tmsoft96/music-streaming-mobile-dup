import 'package:flutter/material.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/components/contentDisplayFull.dart';

Widget morePodcastcastFullWidget({
  @required BuildContext? context,
  @required void Function(AllRadioData data)? onBroadcast,
  @required void Function(AllRadioData data)? onBroadcastMore,
  @required void Function(AllRadioData data)? onBroadcastPlay,
  @required AllPodcastModel? model,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: SingleChildScrollView(
      child: Column(
        children: [
          if (model!.data!.length == 0)
            emptyBox(
              context!,
              msg: "No Broadcast available",
            ),
          if (model.data!.length > 0)
            for (int x = 0; x < model.data!.length; ++x)
              contentDisplayFull(
                context: context,
                image: model.data![x].cover,
                streamNumber: model.data![x].streams!.length,
                title: model.data![x].title,
                artistName: model.data![x].stageName,
                onContent: () => onBroadcast!(model.data![x]),
                onContentMore: () => onBroadcastMore!(model.data![x]),
                onContentPlay: () => onBroadcastPlay!(model.data![x]),
              ),
        ],
      ),
    ),
  );
}
