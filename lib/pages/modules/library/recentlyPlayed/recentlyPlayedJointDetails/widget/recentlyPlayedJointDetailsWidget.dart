import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/models/recentlyPlayedJointModel.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget recentlyPlayedJointDetailsWidget({
  @required BuildContext? context,
  @required RecentlyPlayedJointData? data,
  @required void Function()? onBack,
  @required void Function()? onReadMore,
  @required void Function()? onPlayAll,
  @required void Function()? onDownloadAll,
  @required void Function()? onFavorite,
  @required void Function()? onMorePopUp,
  @required void Function(RecentlyPlayedContent content)? onMusic,
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
      SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onBack,
                icon: Icon(Icons.arrow_back),
                color: BLACK,
              ),
              IconButton(
                onPressed: onMorePopUp,
                icon: Icon(Icons.more_vert),
                color: BLACK,
              ),
            ],
          ),
        ),
      ),
      SafeArea(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.only(top: 60),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: cachedImage(
                    context: context,
                    image: data.cover,
                    height: 200,
                    width: 200,
                    diskCache: null,
                  ),
                ),
                SizedBox(height: 10),
                Text("${data.title}", style: h3WhiteBold),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FeatherIcons.user, color: BLACK, size: 20),
                    SizedBox(width: 10),
                    Text("${data.artistName}", style: h5White),
                  ],
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
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
                                if ("${data.contentType}${data.id}" ==
                                    downloadData.id) {
                                  for (var content in downloadData.content!) {
                                    contentDownload =
                                        downloadData.fileDownloaded!;
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
                                  icon:
                                      Icon(Icons.download_done, color: GREEN1),
                                  height: 40,
                                );
                              } else if (isDownloading) {
                                return button(
                                  onPressed: () => navigation(
                                      context: context,
                                      pageName: "downloadplay"),
                                  text: "Downloading",
                                  color: WHITE,
                                  context: context,
                                  textStyle: h4Black,
                                  textColor: PRIMARYCOLOR,
                                  useWidth: false,
                                  icon: Icon(Icons.downloading,
                                      color: PRIMARYCOLOR),
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
                      SizedBox(width: 10),
                      CircleAvatar(
                        backgroundColor: PRIMARYCOLOR1,
                        child: IconButton(
                          color: BLACK,
                          onPressed: onFavorite,
                          icon: Icon(Icons.favorite_border),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                for (var content in data.content!) ...[
                  ListTile(
                    onTap: () => onMusic!(content),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: cachedImage(
                        context: context,
                        image: content.cover,
                        height: 60,
                        width: 60,
                        diskCache: 150,
                      ),
                    ),
                    title: Text(content.title!, style: h5White),
                    subtitle: Text(content.stageName!, style: h6White),
                    trailing: Icon(
                      Icons.play_circle,
                      size: 30,
                      color: PRIMARYCOLOR,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
