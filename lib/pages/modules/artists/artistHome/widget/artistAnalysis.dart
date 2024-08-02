import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:rally/components/loadingView.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allFollowersModel.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget artistAnalysis({
  @required BuildContext? context,
  @required AllFollowersModel? allFollowersModel,
  @required AllMusicModel? allMusicModel,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Analytics", style: h4WhiteBold),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _layout(
            context: context,
            text: allFollowersModel == null || allFollowersModel.data == null
                ? null
                : allFollowersModel.data!.length > 0
                    ? "${getNumberFormat(allFollowersModel.data!.length)}"
                    : "0",
            title: "Total Followers",
            icon: FeatherIcons.users,
          ),
          SizedBox(width: 5),
          _layout(
            context: context,
            text: allMusicModel == null || allMusicModel.data == null
                ? null
                : allMusicModel.data!.length > 0
                    ? "${getNumberFormat(allMusicModel.totalStream!)}"
                    : "0",
            title: "Total Streams",
            icon: Icons.play_circle,
          ),
          SizedBox(width: 5),
          _layout(
            context: context,
            text: allMusicModel == null || allMusicModel.data == null
                ? null
                : allMusicModel.data!.length > 0
                    ? "${getNumberFormat(allMusicModel.data!.length)}"
                    : "0",
            title: "Total Contents",
            icon: FeatherIcons.folder,
          ),
        ],
      ),
    ],
  );
}

Widget _layout({
  @required BuildContext? context,
  @required String? text,
  @required String? title,
  @required IconData? icon,
}) {
  return Container(
    width: MediaQuery.of(context!).size.width * .3,
    constraints: BoxConstraints(minHeight: 140),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: PRIMARYCOLOR1,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: BLACK),
        SizedBox(height: 10),
        if (text == null) loadingDoubleBounce(BLACK, size: 30),
        if (text != null) Text("$text", style: h2WhiteBold),
        SizedBox(height: 10),
        Text("$title", style: h6White),
      ],
    ),
  );
}
