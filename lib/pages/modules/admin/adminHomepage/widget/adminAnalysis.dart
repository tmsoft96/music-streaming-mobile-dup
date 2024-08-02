import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:rally/components/loadingView.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allArtistsModel.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/models/allRegularUserModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget adminAnalysis({
  @required BuildContext? context,
  @required AllMusicModel? allMusicModel,
  @required AllArtistsModel? allApprovedArtistsModel,
  @required AllArtistsModel? allDeclinedArtistsModel,
  @required AllArtistsModel? allPendingArtistsModel,
  @required AllRegularUserModel? allRegularUserModel,
  @required AllPodcastModel? allRadioModel,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Analytics", style: h5WhiteBold),
      SizedBox(height: 10),
      Wrap(
        spacing: 5,
        runSpacing: 5,
        children: [
          _layout(
            context: context,
            text: [
              '${allApprovedArtistsModel == null || allApprovedArtistsModel.data == null ? null : allApprovedArtistsModel.data!.length > 0 ? "${getNumberFormat(allApprovedArtistsModel.data!.length)}" : "0"}',
              '${allPendingArtistsModel == null || allPendingArtistsModel.data == null ? null : allPendingArtistsModel.data!.length > 0 ? "${getNumberFormat(allPendingArtistsModel.data!.length)}" : "0"}',
              '${allDeclinedArtistsModel == null || allDeclinedArtistsModel.data == null ? null : allDeclinedArtistsModel.data!.length > 0 ? "${getNumberFormat(allDeclinedArtistsModel.data!.length)}" : "0"}',
            ],
            title: ["Approved", "Pending", "Declined"],
            icon: [
              FeatherIcons.users,
              FeatherIcons.userPlus,
              FeatherIcons.userX,
            ],
            mainText: "Total Artists",
          ),
          _layout(
            context: context,
            text: [
              '${allRegularUserModel == null || allRegularUserModel.data == null ? null : allRegularUserModel.data!.length > 0 ? "${getNumberFormat(allRegularUserModel.data!.length)}" : "0"}',
            ],
            title: [""],
            icon: [FeatherIcons.users],
            mainText: "Total Regular Users",
          ),
          _layout(
            context: context,
            text: [
              '${allRadioModel == null || allRadioModel.data == null ? null : allRadioModel.data!.length > 0 ? "${getNumberFormat(allRadioModel.data!.length)}" : "0"}',
              '${allRadioModel == null || allRadioModel.data == null ? null : allRadioModel.data!.length > 0 ? "${getNumberFormat(allRadioModel.totalStream!)}" : "0"}',
            ],
            title: ["Total Podcast", "Total Streams"],
            icon: [Icons.radio, FeatherIcons.radio],
          ),
          _layout(
            context: context,
            text: [
              '${allMusicModel == null || allMusicModel.data == null ? null : allMusicModel.data!.length > 0 ? "${getNumberFormat(allMusicModel.data!.length)}" : "0"}',
              '${allMusicModel == null || allMusicModel.data == null ? null : allMusicModel.data!.length > 0 ? "${getNumberFormat(allMusicModel.totalStream!)}" : "0"}',
            ],
            title: ["Total Contents", "Total Streams"],
            icon: [FeatherIcons.music, FeatherIcons.radio],
          ),
        ],
      ),
    ],
  );
}

Widget _layout({
  @required BuildContext? context,
  @required List<String?>? text,
  @required List<String>? title,
  @required List<IconData>? icon,
  String? mainText,
}) {
  return Container(
    width: MediaQuery.of(context!).size.width * .46,
    constraints: BoxConstraints(minHeight: 140),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: PRIMARYCOLOR1,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int x = 0; x < text!.length; ++x)
              Container(
                width: text.length == 3
                    ? MediaQuery.of(context).size.width * .1
                    : text.length == 2
                        ? MediaQuery.of(context).size.width * .2
                        : MediaQuery.of(context).size.width * .4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon![x], color: BLACK),
                    SizedBox(height: 10),
                    if (text[x] == null) loadingDoubleBounce(BLACK, size: 30),
                    if (text[x] == "null") loadingDoubleBounce(BLACK, size: 30),
                    if (text[x] != null && text[x] != "null")
                      Center(
                        child: FittedBox(
                          child: Text(
                            "${text[x]}",
                            style: text.length == 2 ? h3WhiteBold : h2WhiteBold,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    SizedBox(height: 10),
                    Text(
                      "${title![x]}",
                      style: text.length == 3 ? h7White : h6White,
                      overflow: text.length == 3 ? TextOverflow.ellipsis : null,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ],
        ),
        if (mainText != null) ...[
          SizedBox(height: 3),
          FittedBox(child: Text(mainText, style: h5WhiteBold)),
        ],
      ],
    ),
  );
}
