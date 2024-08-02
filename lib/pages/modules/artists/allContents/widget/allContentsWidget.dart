import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/pages/modules/music/album/artistTopAlbums/artistAlbums.dart';
// import 'package:rally/pages/modules/music/musicVideo/artistMusicVideos/artistMusicVideos.dart';
import 'package:rally/pages/modules/music/songs/artistSongs/artistSongs.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget allContentsWidget({
  @required String? artistId,
  @required String? artistName,
  @required String? artistEmail,
  @required String? artistPicture,
  @required String? followersCount,
  @required String? streamsCount,
  @required BuildContext? context,
  @required bool? userFollowing,
  @required void Function()? onFollow,
}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
          height: MediaQuery.of(context!).size.height * .35,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              cachedImage(
                context: context,
                image: "$artistPicture",
                height: MediaQuery.of(context).size.height * .35,
                width: double.maxFinite,
                placeholder: DEFAULTPROFILEPICOFFLINE,
                diskCache: null,
              ),
              Container(
                color: PRIMARYCOLOR.withOpacity(.5),
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text("$artistName", style: h4BlackBold),
                      subtitle: Text(
                        "${getNumberFormat(int.parse(streamsCount!))} Total Play - Followers: ${getNumberFormat(int.parse(followersCount!))}",
                        style: h5BlackBold,
                      ),
                      trailing: button(
                        onPressed: onFollow,
                        text: userFollowing! ? "Unfollow" : "Follow",
                        color: PRIMARYCOLOR,
                        context: context,
                        useWidth: false,
                        height: 30,
                        textStyle: h5BlackBold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        ArtistSongs(
          artistId: artistId,
          artistName: artistName,
        ),
        ArtistAlbums(
          artistId: artistId,
          artistName: artistName,
        ),
        // ArtistMusicVideos(
        //   artistId: artistId,
        //   artistName: artistName,
        // ),
      ],
    ),
  );
}
