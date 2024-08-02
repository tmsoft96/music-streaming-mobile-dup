import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/contentDisplayDetails.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/models/bannersModel.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget bannerDetailsWidget({
  @required BuildContext? context,
  @required AllBannersData? data,
  @required void Function(Files file)? onTrack,
  @required void Function(dynamic action, Files file)? onTrackMore,
  @required void Function(Files file)? onDownloadTrack,
  @required void Function()? onPlayAll,
  @required void Function()? onDownloadAll,
}) {
  return Stack(
    children: [
      Blur(
        blur: 30,
        blurColor: BACKGROUND,
        child: cachedImage(
          context: context,
          image: data!.cover,
          height: MediaQuery.of(context!).size.height,
          width: MediaQuery.of(context).size.width,
          placeholder: NOAUDIOCOVER,
        ),
      ),
      Container(color: BACKGROUND.withOpacity(.7)),
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: cachedImage(
                  context: context,
                  image: data.cover,
                  height: 150,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                  diskCache: 200,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: Text("${data.files!.length} songs", style: h5White),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  button(
                    onPressed: onPlayAll,
                    text: "Play All",
                    color: PRIMARYCOLOR,
                    context: context,
                    textStyle: h4Black,
                    useWidth: false,
                    icon: Icon(Icons.play_arrow),
                    height: 40,
                  ),
                  SizedBox(width: 10),
                  StreamBuilder(
                    stream: allDownloadStream,
                    initialData: allDownloadModel ?? null,
                    builder: (BuildContext context,
                        AsyncSnapshot<AllDownloadModel> snapshot) {
                      if (snapshot.hasData) {
                        bool contentDownload = false, isDownloading = false;

                        if (snapshot.data != null &&
                            snapshot.data!.data != null) {
                          for (var downloadData in snapshot.data!.data!) {
                            if ("banner${data.id}" == downloadData.id) {
                              for (var content in downloadData.content!) {
                                contentDownload = downloadData.fileDownloaded!;
                                isDownloading = content.isDownloading!;
                                break;
                              }
                            }
                          }

                          if (contentDownload) {
                            return button(
                              onPressed: () => navigation(
                                  context: context,
                                  pageName: "downloadlibrary"),
                              text: "Downloaded",
                              color: WHITE,
                              context: context,
                              textStyle: h4Black,
                              textColor: GREEN1,
                              useWidth: false,
                              icon: Icon(Icons.download_done, color: GREEN1),
                              height: 40,
                            );
                          } else if (isDownloading) {
                            return button(
                              onPressed: () => navigation(
                                  context: context, pageName: "downloadplay"),
                              text: "Downloading",
                              color: WHITE,
                              context: context,
                              textStyle: h4Black,
                              textColor: PRIMARYCOLOR,
                              useWidth: false,
                              icon: Icon(Icons.downloading, color: PRIMARYCOLOR),
                              height: 40,
                            );
                          }
                        }
                        return button(
                          onPressed: onDownloadAll,
                          text: "Download All",
                          color: WHITE,
                          context: context,
                          textColor: BLACK,
                          textStyle: h4Black,
                          useWidth: false,
                          icon: Icon(Icons.download_rounded, color: BLACK),
                          height: 40,
                        );
                      }
                      return button(
                        onPressed: onDownloadAll,
                        text: "Download All",
                        color: WHITE,
                        context: context,
                        textColor: BLACK,
                        textStyle: h4Black,
                        useWidth: false,
                        icon: Icon(Icons.download_rounded, color: BLACK),
                        height: 40,
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                for (var data in data.files!) ...[
                  contentDisplayDetails(
                    context: context,
                    onTrack: () => onTrack!(data),
                    onDownloadTrack: () => onDownloadTrack!(data),
                    cover: data.cover,
                    onTrackMore: (dynamic action) => onTrackMore!(action, data),
                    title: data.title,
                    artistName: data.stageName,
                    contentId: data.id.toString(),
                    contentType: 'single',
                  ),
                  SizedBox(height: 10),
                ],
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
