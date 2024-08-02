import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/models/allPlaylistsModel.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget playlistDetailsWidget({
  @required BuildContext? context,
  @required AllPlaylistsData? allPlaylistsData,
  @required void Function()? onBack,
  @required void Function()? onReadMore,
  @required void Function()? onPlayAll,
  @required void Function()? onDownloadAll,
  @required void Function()? onFavorite,
  @required void Function()? onMorePopUp,
  @required void Function(Content content)? onMusic,
  @required void Function(Content content)? onDeletePlaylistConent,
}) {
  return Stack(
    children: [
      Blur(
        blur: 30,
        blurColor: BACKGROUND,
        child: cachedImage(
          context: context,
          image: allPlaylistsData!.media!.thumb,
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
                    image: allPlaylistsData.media!.normal,
                    height: 200,
                    width: 200,
                    diskCache: null,
                  ),
                ),
                SizedBox(height: 10),
                Text("${allPlaylistsData.title}", style: h3WhiteBold),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FeatherIcons.user, color: BLACK, size: 20),
                    SizedBox(width: 10),
                    Text(
                      "${allPlaylistsData.user!.stageName == '' || allPlaylistsData.user!.stageName == null ? allPlaylistsData.user!.name : allPlaylistsData.user!.stageName}",
                      style: h5White,
                    ),
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
                                if ("playlist${allPlaylistsData.id}" ==
                                    downloadData.id) {
                                  for (var content in downloadData.content!) {
                                    contentDownload = content.downloaded!;
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
                                  icon: Icon(
                                    Icons.downloading,
                                    color: PRIMARYCOLOR,
                                  ),
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
                      StreamBuilder(
                        stream: favoriteContentModelStream,
                        initialData: favoriteContentModel ?? null,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            // FavoriteContentModel model = snapshot.data;

                            return CircleAvatar(
                              backgroundColor: checkContentFavorite(
                                contentId: allPlaylistsData.id.toString(),
                                type: "playlist",
                              )
                                  ? PRIMARYCOLOR
                                  : WHITE,
                              child: IconButton(
                                color: checkContentFavorite(
                                  contentId: allPlaylistsData.id.toString(),
                                  type: "playlist",
                                )
                                    ? WHITE
                                    : BLACK,
                                onPressed: onFavorite,
                                icon: Icon(
                                  checkContentFavorite(
                                    contentId: allPlaylistsData.id.toString(),
                                    type: "playlist",
                                  )
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                ),
                              ),
                            );
                          }
                          return CircleAvatar(
                            backgroundColor: PRIMARYCOLOR1,
                            child: IconButton(
                              color: BLACK,
                              onPressed: onFavorite,
                              icon: Icon(Icons.favorite_border),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                for (var content in allPlaylistsData.content!) ...[
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
                    trailing: userModel!.data!.user!.userid ==
                            allPlaylistsData.userid
                        ? IconButton(
                            onPressed: () => onDeletePlaylistConent!(content),
                            icon: Icon(
                              Icons.remove_circle,
                              color: PRIMARYCOLOR,
                            ),
                          )
                        : Icon(
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
