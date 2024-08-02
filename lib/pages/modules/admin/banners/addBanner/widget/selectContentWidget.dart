import 'package:flutter/material.dart';
import 'package:rally/components/toggleBar.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/components/contentDisplayFull.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget selectContentWidget({
  @required BuildContext? context,
  @required void Function(AllMusicData data)? onMusic,
  @required AllMusicModel? model,
  @required void Function(int index)? onTap,
  @required int? tapIndex,
}) {
  return Stack(
    children: [
      ToggleBar(
        labels: ["Audios", "Videos"],
        selectedTabColor: PRIMARYCOLOR,
        backgroundColor: PRIMARYCOLOR1,
        textColor: BLACK,
        selectedTextColor: BLACK,
        onSelectionUpdated: (index) => onTap!(index),
        labelTextStyle: h5BlackBold,
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(top: 60),
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (int x = 0; x < model!.data!.length; ++x) ...[
                if (tapIndex == 0)
                  if (!model.data![x].filepath!.split("/").last.contains("mp4"))
                    contentDisplayFull(
                      context: context,
                      image: model.data![x].cover,
                      streamNumber: model.data![x].streams!.length,
                      title: model.data![x].title,
                      artistName: model.data![x].stageName,
                      onContent: () => onMusic!(model.data![x]),
                      onContentMore: null,
                      onContentPlay: null,
                    ),
                if (tapIndex == 1)
                  if (model.data![x].filepath!.split("/").last.contains("mp4"))
                    contentDisplayFull(
                      context: context,
                      image: model.data![x].cover,
                      streamNumber: model.data![x].streams!.length,
                      title: model.data![x].title,
                      artistName: model.data![x].stageName,
                      onContent: () => onMusic!(model.data![x]),
                      onContentMore: null,
                      onContentPlay: null,
                    ),
              ],
            ],
          ),
        ),
      ),
    ],
  );
}
