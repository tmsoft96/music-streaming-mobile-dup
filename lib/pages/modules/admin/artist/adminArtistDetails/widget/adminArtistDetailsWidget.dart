import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allArtistsModel.dart';
import 'package:rally/models/allFollowersModel.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/pages/modules/artists/artistHome/widget/artistHomepageWidget.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget adminArtistDetailsWidget({
  @required BuildContext? context,
  @required void Function()? onArtist,
  @required void Function()? onSeeAllHits,
  @required void Function()? onAddContent,
  @required AllFollowersModel? allFollowersModel,
  @required AllMusicModel? allMusicModel,
  @required void Function(int index)? onTap,
  @required int? tabIndex,
  @required AllArtistData? data,
}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(height: 10),
        ListTile(
          onTap: () => onArtist!(),
          tileColor: BLACK,
          leading: circular(
            child: cachedImage(
              context: context,
              image: "${data!.picture}",
              height: 60,
              width: 60,
              placeholder: DEFAULTPROFILEPICOFFLINE,
            ),
            size: 60,
          ),
          title: Text(
            "${data.name} (${data.stageName ?? 'N/A'})",
            style: h3BlackBold,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2),
              Text("${data.phone}", style: h5Black),
              SizedBox(height: 2),
              Text("${data.email}", style: h5Black),
            ],
          ),
        ),
        artistHomepageWidget(
          context: context,
          onHomepage: null,
          onAddContent: onAddContent,
          onNotification: () {},
          onSeeAllHits: onSeeAllHits,
          onInviteFriend: () => inviteFrinds(),
          fromAdminPage: true,
          allFollowersModel: allFollowersModel,
          allMusicModel: allMusicModel,
          onTap: (int index) => onTap!(index),
          tabIndex: tabIndex,
          artistId: data.userid,
        ),
      ],
    ),
  );
}
