import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/generalPopup.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget contentDisplayDetails({
  @required String? cover,
  @required String? title,
  @required String? artistName,
  @required BuildContext? context,
  @required void Function()? onTrack,
  @required void Function()? onDownloadTrack,
  @required void Function(dynamic action)? onTrackMore,
  @required String? contentId,
  @required String? contentType,
}) {
  return ListTile(
    onTap: onTrack,
    leading: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: cachedImage(
        context: context,
        image: cover,
        height: 60,
        width: 60,
        placeholder: NOAUDIOCOVER,
      ),
    ),
    title: Text(
      "$title",
      style: h5WhiteBold,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: Text("$artistName", style: h7White),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: PRIMARYCOLOR1,
          ),
          child: StreamBuilder(
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
                    return CircleAvatar(
                      backgroundColor: WHITE,
                      child: IconButton(
                        onPressed: () => navigation(
                            context: context, pageName: "downloadlibrary"),
                        icon: Icon(
                          Icons.download_done,
                          color: GREEN1,
                        ),
                      ),
                    );
                  } else if (isDownloading) {
                    return GestureDetector(
                      onTap: () => navigation(
                          context: context, pageName: "downloadpage"),
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(PRIMARYCOLOR),
                      ),
                    );
                  }
                }
                return CircleAvatar(
                  backgroundColor: WHITE,
                  child: IconButton(
                    onPressed: onDownloadTrack,
                    icon: Icon(
                      Icons.download_rounded,
                      color: BLACK,
                    ),
                  ),
                );
              }
              return CircleAvatar(
                backgroundColor: WHITE,
                child: IconButton(
                  onPressed: onDownloadTrack,
                  icon: Icon(
                    Icons.download_rounded,
                    color: BLACK,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(width: 5),
        generalPopup(
          onAction: (dynamic action) => onTrackMore!(action),
          contentId: contentId,
          contentType: contentType,
        ),
      ],
    ),
  );
}
