import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/models/allArtistsModel.dart';
import 'package:rally/models/allMusicAllSongsModel.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/models/allRegularUserModel.dart';
import 'package:rally/pages/modules/admin/adminHomepage/widget/adminMenu.dart';
import 'package:rally/pages/modules/artists/allArtists/allArtists.dart';
import 'package:rally/pages/modules/music/todaysHits/todaysHits.dart';
import 'package:rally/pages/modules/radio/topRadioShow/topPodcastShow.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

import 'adminAnalysis.dart';

Widget adminHomepageWidget({
  @required BuildContext? context,
  @required void Function()? onHomepage,
  @required void Function()? onNotification,
  @required void Function()? onRadio,
  @required void Function()? onArtist,
  @required void Function()? onUsers,
  @required void Function()? onLogs,
  @required void Function()? onAllTopArtists,
  @required AllMusicModel? allMusicModel,
  @required AllArtistsModel? allApprovedArtistsModel,
  @required AllArtistsModel? allDeclinedArtistsModel,
  @required AllArtistsModel? allPendingArtistsModel,
  @required AllRegularUserModel? allRegularUserModel,
  @required AllPodcastModel? allRadioModel,
  @required void Function()? onBanner,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              "Hi ${userModel!.data!.user!.name} 👋",
              style: h3WhiteBold,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onHomepage,
                  icon: Icon(FeatherIcons.home),
                  color: PRIMARYCOLOR,
                  iconSize: 35,
                ),
                // IconButton(
                //   onPressed: onNotification,
                //   icon: Icon(FeatherIcons.bell),
                //   color: PRIMARYCOLOR,
                //   iconSize: 35,
                // ),
              ],
            ),
          ),
          SizedBox(height: 10),
          adminAnalysis(
            context: context,
            allMusicModel: allMusicModel,
            allApprovedArtistsModel: allApprovedArtistsModel,
            allDeclinedArtistsModel: allDeclinedArtistsModel,
            allPendingArtistsModel: allPendingArtistsModel,
            allRegularUserModel: allRegularUserModel,
            allRadioModel: allRadioModel,
          ),
          SizedBox(height: 10),
          Text("Menu", style: h4WhiteBold),
          SizedBox(height: 10),
          adminMenu(
            onRadio: onRadio,
            onArtist: onArtist,
            onUsers: onUsers,
            onLogs: onLogs,
            onBanner: onBanner,
          ),
          SizedBox(height: 10),
          TopPodcastShow(fromAdminPage: true),
          SizedBox(height: 10),
          AllArtists(),
          SizedBox(height: 10),
          TodaysHits(
            fromAdminPage: true,
            allMusicModel: AllMusicAllSongsModel.fromJson(
              json: allMusicModel!.toJson(),
              httpMsg: "",
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    ),
  );
}
