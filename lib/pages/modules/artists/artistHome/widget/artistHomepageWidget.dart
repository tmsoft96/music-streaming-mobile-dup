import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/toggleBar.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/models/allFollowersModel.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/pages/homepage/othersPage/widget/introduceFriendWidget.dart';
import 'package:rally/pages/modules/artists/artistContent/homeArtistAlbumContent/homeArtistAlbumContent.dart';
import 'package:rally/pages/modules/artists/artistContent/homeArtistAudioContent/homeArtistAudioContent.dart';
import 'package:rally/spec/arrays.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/properties.dart';
import 'package:rally/spec/styles.dart';

import 'artistAnalysis.dart';

Widget artistHomepageWidget({
  @required BuildContext? context,
  @required void Function()? onHomepage,
  @required void Function()? onAddContent,
  @required void Function()? onNotification,
  @required void Function()? onSeeAllHits,
  @required void Function()? onInviteFriend,
  bool fromAdminPage = false,
  @required AllFollowersModel? allFollowersModel,
  @required AllMusicModel? allMusicModel,
  @required void Function(int index)? onTap,
  @required int? tabIndex,
  String? artistId,
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
              fromAdminPage
                  ? "Artist Page"
                  : "Hi ${userModel!.data!.user!.fname!} 👋",
              style: h3WhiteBold,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onAddContent,
                  icon: Icon(Icons.add_circle),
                  color: PRIMARYCOLOR,
                  iconSize: 45,
                ),
                if (!fromAdminPage)
                  IconButton(
                    onPressed: onHomepage,
                    icon: Icon(FeatherIcons.home),
                    color: PRIMARYCOLOR,
                    iconSize: 35,
                  ),

                // if (!fromAdminPage)
                //   IconButton(
                //     onPressed: onNotification,
                //     icon: Icon(FeatherIcons.bell),
                //     color: PRIMARYCOLOR,
                //     iconSize: 35,
                //   ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // Text("Latest content performance", style: h4BlackBold),
          // SizedBox(height: 10),
          // ArtistCarouselSlider(artistId: artistId),
          SizedBox(height: 10),
          artistAnalysis(
            context: context,
            allFollowersModel: allFollowersModel,
            allMusicModel: allMusicModel,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Top 5 Hits", style: h4White),
              button(
                onPressed: onSeeAllHits,
                text: 'More >',
                color: BACKGROUND,
                context: context,
                useWidth: false,
                textColor: PRIMARYCOLOR,
              ),
            ],
          ),
          SizedBox(height: 10),
          ToggleBar(
            labels: artistHomepageTabList,
            selectedTabColor: PRIMARYCOLOR,
            backgroundColor: PRIMARYCOLOR1,
            textColor: BLACK,
            selectedTextColor: WHITE,
            onSelectionUpdated: (index) => onTap!(index),
            labelTextStyle: h5BlackBold,
          ),
          SizedBox(height: 10),
          tabIndex == 0
              ? HomeArtistAudioContent(
                  artistId: artistId ?? userModel!.data!.user!.userid,
                )
              : HomeArtistAlbumContent(
                  artistId: artistId ?? userModel!.data!.user!.userid,
                ),
          // tabIndex == 1
          //     ? HomeArtistAlbumContent(
          //         artistId: artistId ?? userModel!.data!.user!.userid,
          //       )
          //     : HomeArtistVideoContent(
          //         artistId: artistId ?? userModel!.data!.user!.userid,
          //       ),
          if (!fromAdminPage) ...[
            introduceFriendWidget(
              context: context,
              onInvite: onInviteFriend,
            ),
            SizedBox(height: 20),
            Center(child: Text("$VERSION", style: h5WhiteBold)),
          ],
          SizedBox(height: 20),
        ],
      ),
    ),
  );
}
