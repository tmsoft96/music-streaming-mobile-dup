import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/models/recentlyPlayedJointModel.dart';
import 'package:rally/models/recentlyPlayedSingleModel.dart';
import 'package:rally/providers/recentlyPlayedJointProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

import 'homeRecentlyAlbum.dart';
import 'homeRecentlyPlayedSinglesWidget.dart';

Widget homeRecentlyPlayedWidget({
  @required BuildContext? context,
  @required void Function()? onViewAllSongs,
  @required void Function(RecentlyPlayedSingleData data)? onTrack,
  @required void Function()? onPlayAll,
  @required void Function()? onSeeAll,
  @required RecentlyPlayedSingleModel? model,
  @required void Function(RecentlyPlayedJointData details)? onJointPlayAll,
  @required void Function(RecentlyPlayedJointData details)? onJointDetails,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Recently Played", style: h4White),
              ],
            ),
          ),
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
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: 10),
            homeRecentlyPlayedSinglesWidget(
              context: context,
              onViewAllSongs: onViewAllSongs,
              onTrack: (RecentlyPlayedSingleData data) => onTrack!(data),
              onPlayAll: onPlayAll,
              model: model,
            ),
            SizedBox(width: 10),
            StreamBuilder(
              stream: recentlyPlayedJointStream,
              initialData: recentlyPlayedJointModel ?? null,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return _jointContentWidget(
                    context: context,
                    model: snapshot.data,
                    onAlbumDetails: (RecentlyPlayedJointData details) =>
                        onJointDetails!(details),
                    onAlbumPlayAll: (RecentlyPlayedJointData details) =>
                        onJointPlayAll!(details),
                  );
                } else if (snapshot.hasError) {
                  return Container();
                }
                return shimmerItem(useGrid: true, numOfItem: 3);
              },
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _jointContentWidget({
  @required BuildContext? context,
  @required RecentlyPlayedJointModel? model,
  @required void Function(RecentlyPlayedJointData details)? onAlbumPlayAll,
  @required void Function(RecentlyPlayedJointData details)? onAlbumDetails,
}) {
  return model!.data != null && model.data!.length > 0
      ? Row(
          children: [
            for (int x = 0;
                x < (model.data!.length >= 4 ? 4 : model.data!.length);
                ++x) ...[
              homeRecentlyAlbum(
                context: context,
                onAlbumPlayAll: () => onAlbumPlayAll!(model.data![x]),
                onAlbumDetails: () => onAlbumDetails!(model.data![x]),
                image: model.data![x].cover,
                title: model.data![x].title,
              ),
              SizedBox(width: 10),
            ],
          ],
        )
      : Container();
}
