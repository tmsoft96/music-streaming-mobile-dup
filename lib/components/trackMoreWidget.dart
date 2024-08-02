import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget trackMoreWidget({
  @required BuildContext? context,
  @required String? contentImage,
  @required String? title,
  @required String? artistName,
  @required String? artistPicture,
  @required String? contentId,
  @required String? contentType,
  @required void Function()? onClose,
  @required void Function()? onArtistProfile,
  @required void Function()? onShare,
  @required void Function()? onFavorite,
  @required void Function()? onAddToPlaylist,
  @required void Function()? onMoreInfo,
  @required void Function()? onReport,
  @required void Function()? onDownload,
}) {
  return Container(
    color: PRIMARYCOLOR1,
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: cachedImage(
                context: context,
                image: contentImage,
                height: 60,
                width: 60,
              ),
            ),
            title: Text("$title", style: h5WhiteBold),
            subtitle: Text("$artistName", style: h6White),
            trailing: IconButton(
              color: BLACK,
              icon: Icon(Icons.close),
              onPressed: onClose,
            ),
          ),
          Divider(color: BLACK),
          if (onArtistProfile != null) ...[
            ListTile(
              onTap: () {
                navigation(context: context, pageName: "back");
                onArtistProfile();
              },
              leading: circular(
                child: cachedImage(
                  context: context,
                  image: artistPicture ?? contentImage,
                  height: 30,
                  width: 30,
                  placeholder: DEFAULTPROFILEPICOFFLINE,
                ),
                size: 30,
              ),
              title: Text("More from \"$artistName\"", style: h5WhiteBold),
              visualDensity: VisualDensity(vertical: -3),
              dense: true,
            ),
            Divider(indent: 60, color: GREY, thickness: .2),
          ],
          if (onShare != null) ...[
            ListTile(
              onTap: () {
                navigation(context: context, pageName: "back");
                onShare();
              },
              leading: Icon(Icons.share, size: 30, color: BLACK),
              title: Text(
                "Share \"$title\"",
                style: h5WhiteBold,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              visualDensity: VisualDensity(vertical: -3),
              dense: true,
            ),
            Divider(indent: 60, color: GREY, thickness: .2),
          ],
          ListTile(
            onTap: () {
              navigation(context: context, pageName: "back");
              onFavorite!();
            },
            leading: Icon(Icons.favorite, size: 30, color: BLACK),
            title: StreamBuilder(
              stream: favoriteContentModelStream,
              initialData: favoriteContentModel ?? null,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  // FavoriteContentModel model = snapshot.data;
                  return checkContentFavorite(
                    contentId: contentId,
                    type: contentType,
                  )
                      ? Text(
                          "UnLike \"$title\"",
                          style: h5WhiteBold,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          "Like \"$title\"",
                          style: h5WhiteBold,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        );
                }
                return Text(
                  "Like \"$title\"",
                  style: h5WhiteBold,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
            visualDensity: VisualDensity(vertical: -3),
            dense: true,
          ),
          Divider(indent: 60, color: GREY, thickness: .2),
          if (onDownload != null) ...[
            StreamBuilder(
              stream: allDownloadStream,
              initialData: allDownloadModel ?? null,
              builder: (BuildContext context,
                  AsyncSnapshot<AllDownloadModel> snapshot) {
                if (snapshot.hasData) {
                  bool contentDownload = false, isDownloading = false;

                  if (snapshot.data != null && snapshot.data!.data != null) {
                    for (var downloadData in snapshot.data!.data!) {
                      if (contentType != "single" &&
                          "$contentType$contentId" == downloadData.id) {
                        for (var content in downloadData.content!) {
                          contentDownload = downloadData.fileDownloaded!;
                          isDownloading = content.isDownloading!;
                          break;
                        }

                        break;
                      } else {
                        for (var content in downloadData.content!) {
                          if (contentId == content.id) {
                            contentDownload = downloadData.fileDownloaded!;
                            isDownloading = content.isDownloading!;
                            break;
                          }
                        }
                      }
                    }
                    if (contentDownload) {
                      return ListTile(
                        onTap: () {
                          navigation(context: context, pageName: "back");
                          navigation(
                            context: context,
                            pageName: "downloadlibrary",
                          );
                        },
                        leading:
                            Icon(Icons.download_done, size: 30, color: GREEN1),
                        title: Text(
                          "Downloaded \"$title\"",
                          style: h5WhiteBold,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        visualDensity: VisualDensity(vertical: -3),
                        dense: true,
                      );
                    } else if (isDownloading) {
                      return ListTile(
                        onTap: () {
                          navigation(context: context, pageName: "back");
                          navigation(
                            context: context,
                            pageName: "downloadpage",
                          );
                        },
                        leading: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(PRIMARYCOLOR),
                        ),
                        title: Text(
                          "Downloading \"$title\"",
                          style: h5PrimaryBold,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        visualDensity: VisualDensity(vertical: -3),
                        dense: true,
                      );
                    }
                  }
                  return ListTile(
                    onTap: () {
                      navigation(context: context, pageName: "back");
                      onDownload();
                    },
                    leading: Icon(Icons.download, size: 30, color: BLACK),
                    title: Text(
                      "Download \"$title\"",
                      style: h5WhiteBold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    visualDensity: VisualDensity(vertical: -3),
                    dense: true,
                  );
                }
                return ListTile(
                  onTap: () {
                    navigation(context: context, pageName: "back");
                    onDownload();
                  },
                  leading: Icon(Icons.download, size: 30, color: BLACK),
                  title: Text(
                    "Download \"$title\"",
                    style: h5WhiteBold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  visualDensity: VisualDensity(vertical: -3),
                  dense: true,
                );
              },
            ),
            Divider(indent: 60, color: GREY, thickness: .2),
          ],
          ListTile(
            onTap: () {
              navigation(context: context, pageName: "back");
              onAddToPlaylist!();
            },
            leading: Icon(Icons.playlist_add, size: 30, color: BLACK),
            title: Text("Add to Playlist", style: h5WhiteBold),
            visualDensity: VisualDensity(vertical: -3),
            dense: true,
          ),
          Divider(indent: 60, color: GREY, thickness: .2),
          if (onMoreInfo != null) ...[
            ListTile(
              onTap: () {
                navigation(context: context, pageName: "back");
                onMoreInfo();
              },
              leading: Icon(Icons.info_outline, size: 30, color: BLACK),
              title: Text("More Info", style: h5WhiteBold),
              visualDensity: VisualDensity(vertical: -3),
              dense: true,
            ),
            Divider(indent: 60, color: GREY, thickness: .2),
          ],
          if (onReport != null) ...[
            ListTile(
              onTap: () {
                navigation(context: context, pageName: "back");
                onReport();
              },
              leading: Icon(Icons.report, size: 30, color: BLACK),
              title: Text("Report", style: h5WhiteBold),
              visualDensity: VisualDensity(vertical: -3),
              dense: true,
            ),
          ],
          SizedBox(height: 10),
        ],
      ),
    ),
  );
}
