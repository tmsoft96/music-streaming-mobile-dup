import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget podcastAnalysis({
  @required BuildContext? context,
  @required AllPodcastModel? model,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text("Analytics", style: h4WhiteBold),
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _layout(
            context: context,
            text: model!.data!.length > 0
                ? "${getNumberFormat(model.data!.length)}"
                : "0",
            title: "Total Broadcast",
            icon: Icons.radio,
          ),
          SizedBox(width: 5),
          _layout(
            context: context,
            text: model.data!.length > 0
                ? "${getNumberFormat(model.totalStream!)}"
                : "0",
            title: "Total Streams",
            icon: FeatherIcons.radio,
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
    width: MediaQuery.of(context!).size.width * .47,
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
        Text("$text", style: h2WhiteBold),
        SizedBox(height: 10),
        Text("$title", style: h6White),
      ],
    ),
  );
}
