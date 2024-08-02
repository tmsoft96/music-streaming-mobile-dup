import 'package:flutter/material.dart';
import 'package:rally/models/recentlyPlayedSingleModel.dart';
import 'package:rally/pages/modules/library/recentlyPlayed/homeRecentlyPlayed/widget/homeRecentlyPlayedSinglesWidget.dart';

import 'allRecentlyPlayedJointWidget.dart';

Widget allRecentlyPlayedWidget({
  @required BuildContext? context,
  @required void Function()? onViewAllSongs,
  @required void Function(RecentlyPlayedSingleData data)? onTrack,
  @required void Function()? onPlayAll,
  @required RecentlyPlayedSingleModel? model,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Stack(
      children: [
        homeRecentlyPlayedSinglesWidget(
          context: context,
          onViewAllSongs: onViewAllSongs,
          onTrack: (RecentlyPlayedSingleData data) => onTrack!(data),
          onPlayAll: onPlayAll,
          model: model,
          divideWidth: .93,
        ),
        Container(
          margin: EdgeInsets.only(top: 170),
          child: AllRecentlyPlayedJointWidget(),
        ),
      ],
    ),
  );
}
