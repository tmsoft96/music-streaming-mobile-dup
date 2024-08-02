import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/toggleBar.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/allAlbumModel.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/models/checkFollowingModel.dart';
import 'package:rally/pages/modules/music/album/artistTopAlbums/artistAlbums.dart';
import 'package:rally/pages/modules/music/songs/artistSongs/artistSongs.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/arrays.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

import 'albumsDetailsInfo.dart';
import 'albumsDetailsReviews.dart';
import 'albumsDetailsTrack.dart';

bool albumsDetialsContentDownloaded = false;

Widget albumsDetailsWidget({
  @required BuildContext? context,
  @required void Function()? onPlayAlbum,
  @required void Function()? onFollow,
  @required void Function(int index)? onTap,
  @required void Function(AllMusicData data)? onTrack,
  @required void Function(double rating)? onRating,
  @required int? tabIndex,
  @required AllMusicData? allMusicData,
  @required AllAlbumData? allAlbumData,
  @required CheckFollowingModel? checkFollowingModel,
  @required void Function(ContentFile file)? onAlbumTrack,
  @required void Function()? onDownload,
  @required void Function()? onComment,
  @required void Function()? onFavorite,
  @required void Function()? onSingleDownload,
  @required void Function(ContentFile file)? onAlbumDownload,
  @required void Function(dynamic action, ContentFile file)? onAlbumTrackMore,
  @required void Function(dynamic action)? onSingleTrackMore,
}) {
  return Stack(
    children: [
      Blur(
        blur: 30,
        blurColor: BACKGROUND,
        child: cachedImage(
          context: context,
          image:
              allMusicData != null ? allMusicData.cover : allAlbumData!.cover,
          height: MediaQuery.of(context!).size.height,
          width: MediaQuery.of(context).size.width,
          placeholder: NOAUDIOCOVER,
        ),
      ),
      Container(color: BACKGROUND.withOpacity(.7)),
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: cachedImage(
                  context: context,
                  image: allMusicData != null
                      ? allMusicData.cover
                      : allAlbumData!.cover,
                  height: 200,
                  width: 200,
                  diskCache: null,
                ),
              ),
              ListTile(
                title: Text(
                  "${allMusicData != null ? allMusicData.title : allAlbumData!.name}",
                  style: h4WhiteBold,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  "${allMusicData != null ? (allMusicData.stageName == null ? allMusicData.user!.name : allMusicData.stageName) : allAlbumData!.stageName}",
                  style: h6White,
                ),
                trailing: button(
                  onPressed: onFollow,
                  text: checkFollowingModel != null &&
                          checkFollowingModel.data != null &&
                          checkFollowingModel.data! == 1
                      ? "Unfollow"
                      : "Follow",
                  color: BLACK,
                  textColor: BLACK,
                  context: context,
                  useWidth: false,
                  height: 30,
                  textStyle: h5BlackBold,
                  colorFill: false,
                  backgroundcolor: TRANSPARENT,
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    button(
                      onPressed: onPlayAlbum,
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
                          String contentId = allAlbumData != null
                              ? allAlbumData.id.toString()
                              : allMusicData!.id.toString();
                          String type =
                              allAlbumData != null ? "album" : "single";

                          bool contentDownload = false, isDownloading = false;

                          if (snapshot.data != null &&
                              snapshot.data!.data != null) {
                            for (var downloadData in snapshot.data!.data!) {
                              if ("$type$contentId" == downloadData.id) {
                                for (var content in downloadData.content!) {
                                  contentDownload =
                                      downloadData.fileDownloaded!;
                                  isDownloading = content.isDownloading!;
                                  break;
                                }
                              }
                            }
                            if (contentDownload) {
                              albumsDetialsContentDownloaded = true;
                              return button(
                                onPressed: onDownload,
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
                                icon: Icon(Icons.downloading,
                                    color: PRIMARYCOLOR),
                                height: 40,
                              );
                            }
                          }
                          albumsDetialsContentDownloaded = false;
                          return button(
                            onPressed: onDownload,
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
                        albumsDetialsContentDownloaded = false;
                        return button(
                          onPressed: onDownload,
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
                          String contentId = allAlbumData != null
                              ? allAlbumData.id.toString()
                              : allMusicData!.id.toString();
                          String type =
                              allAlbumData != null ? "album" : "single";
                          return CircleAvatar(
                            backgroundColor: checkContentFavorite(
                              contentId: contentId,
                              type: type,
                            )
                                ? PRIMARYCOLOR
                                : WHITE,
                            child: IconButton(
                              color: checkContentFavorite(
                                contentId: contentId,
                                type: type,
                              )
                                  ? WHITE
                                  : BLACK,
                              onPressed: onFavorite,
                              icon: Icon(
                                checkContentFavorite(
                                  contentId: contentId,
                                  type: type,
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
              SizedBox(height: 10),
              albumsDetailsTrack(
                context: context,
                onTrack: (AllMusicData data) => onTrack!(data),
                allMusicData: allMusicData,
                allAlbumData: allAlbumData,
                onAlbumTrack: (ContentFile file) => onAlbumTrack!(file),
                onAlbumDownload: (ContentFile file) => onAlbumDownload!(file),
                onAlbumTrackMore: (dynamic action, ContentFile file) =>
                    onAlbumTrackMore!(action, file),
                onSingleDownload: () => onSingleDownload!(),
                onSingleTrackMore: (action) => onSingleTrackMore!(action),
              ),
              SizedBox(height: 20),
              Divider(color: BLACK, thickness: .2),
              ToggleBar(
                labels: allMusicData != null
                    ? albumDetailsTabList
                    : albumDetailsTabList2,
                selectedTabColor: WHITE,
                backgroundColor: TRANSPARENT,
                textColor: BLACK,
                selectedTextColor: BLACK,
                onSelectionUpdated: (index) => onTap!(index),
                labelTextStyle: h5BlackBold,
              ),
              Divider(color: BLACK, thickness: .2),
              if (tabIndex == 0)
                albumsDetailsInfo(
                  allMusicData: allMusicData,
                  allAlbumData: allAlbumData,
                ),
              if (allMusicData != null && tabIndex == 1)
                albumsDetailsReviews(
                  context: context,
                  onRating: (double rating) => onRating!(rating),
                  allMusicData: allMusicData,
                  onComment: onComment,
                ),
              if ((allMusicData == null && tabIndex == 1) || tabIndex == 2) ...[
                ArtistSongs(
                  artistId: allMusicData != null
                      ? allMusicData.userid
                      : allAlbumData!.userid,
                  artistName:
                      "${allMusicData != null ? (allMusicData.stageName == null ? allMusicData.user!.name : allMusicData.stageName) : allAlbumData!.stageName}",
                ),
                ArtistAlbums(
                  artistId: allMusicData != null
                      ? allMusicData.userid
                      : allAlbumData!.userid,
                  artistName:
                      "${allMusicData != null ? (allMusicData.stageName == null ? allMusicData.user!.name : allMusicData.stageName) : allAlbumData!.stageName}",
                ),
                // SizedBox(height: 10),
                // ArtistMusicVideos(
                //   artistId: allMusicData != null
                //       ? allMusicData.userid
                //       : allAlbumData!.userid,
                //   artistName:
                //       "${allMusicData != null ? (allMusicData.stageName == null ? allMusicData.user!.name : allMusicData.stageName) : allAlbumData!.stageName}",
                // ),
                // SizedBox(height: 10),
              ],
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    ],
  );
}
