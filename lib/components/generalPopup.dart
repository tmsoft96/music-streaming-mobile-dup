import 'package:flutter/material.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

PopupMenuButton generalPopup({
  @required void Function(dynamic action)? onAction,
  bool showFavoite = true,
  @required String? contentId,
  @required String? contentType,
}) {
  return PopupMenuButton(
    color: WHITE,
    icon: Icon(Icons.more_vert, color: BLACK),
    itemBuilder: (BuildContext bc) => [
      PopupMenuItem(
        child: Row(
          children: [
            Icon(
              Icons.share,
              size: 20,
              color: BLACK,
            ),
            SizedBox(width: 10),
            Text("Share", style: h6White),
          ],
        ),
        value: 0,
      ),
      if (showFavoite)
        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                Icons.favorite,
                size: 20,
                color: BLACK,
              ),
              SizedBox(width: 10),
              StreamBuilder(
                stream: favoriteContentModelStream,
                initialData: favoriteContentModel ?? null,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    // FavoriteContentModel model = snapshot.data;
                    return checkContentFavorite(
                      contentId: contentId,
                      type: contentType,
                    )
                        ? Text("Remove Favorite", style: h6White)
                        : Text("Favorite", style: h6White);
                  }
                  return Text("Favorite", style: h6White);
                },
              ),
            ],
          ),
          value: 1,
        ),
      PopupMenuItem(
        child: Row(
          children: [
            Icon(
              Icons.add_box_outlined,
              size: 20,
              color: BLACK,
            ),
            SizedBox(width: 10),
            Text("Add to Playlist", style: h6White),
          ],
        ),
        value: 2,
      ),
      PopupMenuItem(
        child: StreamBuilder(
          stream: allDownloadStream,
          initialData: allDownloadModel ?? null,
          builder:
              (BuildContext context, AsyncSnapshot<AllDownloadModel> snapshot) {
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
                  return Row(
                    children: [
                      Icon(
                        Icons.download_done_outlined,
                        size: 20,
                        color: GREEN1,
                      ),
                      SizedBox(width: 10),
                      Text("Downloaded", style: h6Green),
                    ],
                  );
                } else if (isDownloading) {
                  Row(
                    children: [
                      Icon(
                        Icons.downloading,
                        size: 20,
                        color: PRIMARYCOLOR,
                      ),
                      SizedBox(width: 10),
                      Text("Downloading", style: h6PrimaryBold),
                    ],
                  );
                }
              }
              return Row(
                children: [
                  Icon(Icons.download, size: 20, color: BLACK),
                  SizedBox(width: 10),
                  Text("Download", style: h6White),
                ],
              );
            }
            return Row(
              children: [
                Icon(Icons.download, size: 20, color: BLACK),
                SizedBox(width: 10),
                Text("Download", style: h6White),
              ],
            );
          },
        ),
        value: 3,
      ),
      PopupMenuItem(
        child: Row(
          children: [
            Icon(
              Icons.report_gmailerrorred_outlined,
              size: 20,
              color: BLACK,
            ),
            SizedBox(width: 10),
            Text("Report", style: h6White),
          ],
        ),
        value: 4,
      ),
    ],
    onSelected: (route) => onAction!(route),
  );
}
