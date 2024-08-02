import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/toggleBar.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/pages/homepage/library/widget/libraryDowloadPreview.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/spec/arrays.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget libraryWidget({
  @required BuildContext? context,
  @required void Function()? onShowDownload,
  @required void Function()? onFavoriteSongs,
  @required void Function()? onFavoritePlaylist,
  @required void Function()? onMyPlaylists,
  @required void Function()? onFavoriteAlbums,
  @required void Function()? onFollwedArtists,
  @required void Function(int index)? onTap,
  @required int? tabIndex,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            onTap: onShowDownload,
            title: Text("Show Downloads", style: h5WhiteBold),
            trailing: Icon(Icons.arrow_forward_ios, color: BLACK),
            contentPadding: EdgeInsets.symmetric(horizontal: 5),
          ),
          StreamBuilder(
            stream: allDownloadStream,
            initialData: allDownloadModel ?? null,
            builder: (BuildContext context,
                AsyncSnapshot<AllDownloadModel> snapshot) {
              if (snapshot.hasData) {
                bool contentDownload = false;
                String contentCover = "";
                List<String> contentTitleList = [];
                if (snapshot.data != null && snapshot.data!.data != null) {
                  for (var downloadData in snapshot.data!.data!) {
                    for (var content in downloadData.content!) {
                      if (content.downloaded!) {
                        contentTitleList.add(content.title!);
                      }
                    }
                    contentDownload = true;
                  }
                  contentCover = snapshot.data!.data!.last.cover!;

                  if (contentDownload) {
                    return libraryDowloadPreview(
                      context: context,
                      onShowDownload: onShowDownload,
                      contentTitle: contentTitleList.length >= 3
                          ? contentTitleList.sublist(contentTitleList.length - 3)
                          : contentTitleList,
                      image: contentCover,
                    );
                  }
                }
                return emptyBoxLinear(context, msg: "No download available");
              }
              return shimmerItem(numOfItem: 1);
            },
          ),
          SizedBox(height: 20),
          ToggleBar(
            labels: libraryTapList,
            selectedTabColor: BACKGROUND,
            backgroundColor: PRIMARYCOLOR1,
            textColor: BLACK,
            selectedTextColor: BLACK,
            onSelectionUpdated: (index) => onTap!(index),
            labelTextStyle: h5BlackBold,
          ),
          SizedBox(height: 10),
          if (tabIndex == 0) ...[
            ListTile(
              onTap: onFavoriteSongs,
              leading: Icon(FeatherIcons.music, size: 25, color: BLACK),
              title: Text("Favorite Songs", style: h5WhiteBold),
              trailing: Icon(Icons.arrow_forward_ios, color: BLACK),
              visualDensity: VisualDensity(vertical: -1),
              dense: true,
            ),
            Divider(indent: 60, color: GREY, thickness: .2),
            ListTile(
              onTap: onFavoritePlaylist,
              leading:
                  Icon(Icons.playlist_play_outlined, size: 25, color: BLACK),
              title: Text("Favorite Playlists", style: h5WhiteBold),
              trailing: Icon(Icons.arrow_forward_ios, color: BLACK),
              visualDensity: VisualDensity(vertical: -1),
              dense: true,
            ),
            Divider(indent: 60, color: GREY, thickness: .2),
            ListTile(
              onTap: onMyPlaylists,
              leading:
                  Icon(Icons.playlist_play_rounded, size: 25, color: BLACK),
              title: Text("My Playlists", style: h5WhiteBold),
              trailing: Icon(Icons.arrow_forward_ios, color: BLACK),
              visualDensity: VisualDensity(vertical: -1),
              dense: true,
            ),
            Divider(indent: 60, color: GREY, thickness: .2),
            ListTile(
              onTap: onFavoriteAlbums,
              leading: Icon(Icons.album_rounded, size: 25, color: BLACK),
              title: Text("Favorite Albums", style: h5WhiteBold),
              trailing: Icon(Icons.arrow_forward_ios, color: BLACK),
              visualDensity: VisualDensity(vertical: -1),
              dense: true,
            ),
            Divider(indent: 60, color: GREY, thickness: .2),
            ListTile(
              onTap: onFollwedArtists,
              leading: Icon(FeatherIcons.users, size: 25, color: BLACK),
              title: Text("Followed Artists", style: h5WhiteBold),
              trailing: Icon(Icons.arrow_forward_ios, color: BLACK),
              visualDensity: VisualDensity(vertical: -1),
              dense: true,
            ),
          ],
          if (tabIndex == 1)
            Container(
              height: 200,
              alignment: Alignment.center,
              child: Text(
                "Comming\nSoon",
                style: h1WhiteBold,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    ),
  );
}
