import 'package:flutter/material.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/contentDisplayDetails.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/models/allAlbumHomepageModel.dart';
import 'package:rally/models/allMusicAllSongsModel.dart';
import 'package:rally/models/allPlaylistsModel.dart';
import 'package:rally/models/favoriteContentModel.dart';
import 'package:rally/providers/allAlbumHomepageProvider.dart';
import 'package:rally/providers/allMusicAllSongsProvider.dart';
import 'package:rally/providers/allPlaylistsProvider.dart';

Widget favoriteDetailsWidget({
  @required BuildContext? context,
  @required void Function(MusicAllSongsData data)? onSingle,
  @required void Function(MusicAllSongsData data)? onDownloadSingle,
  @required void Function(dynamic action, MusicAllSongsData data)? onSingleMore,
  @required void Function(AllAlbumHomepageData data)? onAlbum,
  @required void Function(AllAlbumHomepageData data)? onDownloadAlbum,
  @required
      void Function(dynamic action, AllAlbumHomepageData data)? onAlbumMore,
  @required void Function(AllPlaylistsData data)? onPlaylist,
  @required void Function(AllPlaylistsData data)? onDownloadPlaylist,
  @required
      void Function(dynamic action, AllPlaylistsData data)? onPlaylistMore,
  @required FavoriteContentModel? model,
  @required
      Future<PaginatedItemsResponse<String>?> Function(bool)? fetchPageData,
  @required PaginatedItemsResponse<String>? response,
  @required String? contentType,
}) {
  bool showLayout = false;
  for (String contentid in model!.contentIdList!) {
    if (contentid.contains(contentType!)) {
      showLayout = true;
      break;
    }
  }

  return showLayout
      ? PaginatedItemsBuilder<String>(
          response: response!,
          fetchPageData: (bool reset) => fetchPageData!(reset),
          itemBuilder: (BuildContext context, int index, item) {
            if (contentType == "single") {
              AllMusicAllSongsModel songModel = allMusicAllSongsModel!;
              MusicAllSongsData? musicData;
              if (item.contains(contentType!)) {
                String contentId = item.substring(contentType.length);
                for (var data in songModel.data!) {
                  if (data.id.toString() == contentId) {
                    musicData = data;
                    break;
                  }
                }
              }

              return musicData != null
                  ? contentDisplayDetails(
                      context: context,
                      cover: musicData.media!.thumb,
                      title: musicData.title,
                      artistName: musicData.stageName,
                      onTrack: () => onSingle!(musicData!),
                      onDownloadTrack: () => onDownloadSingle!(musicData!),
                      onTrackMore: (dynamic action) =>
                          onSingleMore!(action, musicData!),
                      contentId: musicData.id.toString(),
                      contentType: contentType,
                    )
                  : SizedBox();
            } else if (contentType == "album") {
              AllAlbumHomepageModel albumModel = allAlbumHomepageModel!;
              AllAlbumHomepageData? albumData;
              if (item.contains(contentType!)) {
                String contentId = item.substring(contentType.length);
                for (var data in albumModel.data!) {
                  if (data.id.toString() == contentId) {
                    albumData = data;
                    break;
                  }
                }
              }

              return albumData != null
                  ? contentDisplayDetails(
                      context: context,
                      cover: albumData.media!.thumb,
                      title: albumData.name,
                      artistName: albumData.stageName,
                      onTrack: () => onAlbum!(albumData!),
                      onDownloadTrack: () => onDownloadAlbum!(albumData!),
                      onTrackMore: (dynamic action) =>
                          onAlbumMore!(action, albumData!),
                      contentId: albumData.id.toString(),
                      contentType: contentType,
                    )
                  : SizedBox();
            } else {
              AllPlaylistsModel playlistModel = allPlaylistsModel!;
              AllPlaylistsData? playlistsData;
              if (item.contains(contentType!)) {
                String contentId = item.substring(contentType.length);
                for (var data in playlistModel.data!) {
                  if (data.id.toString() == contentId) {
                    playlistsData = data;
                    break;
                  }
                }
              }

              return playlistsData != null
                  ? contentDisplayDetails(
                      context: context,
                      cover: playlistsData.media!.thumb,
                      title: playlistsData.title,
                      artistName:
                          '${playlistsData.content!.length.toString()} songs',
                      onTrack: () => onPlaylist!(playlistsData!),
                      onDownloadTrack: () =>
                          onDownloadPlaylist!(playlistsData!),
                      onTrackMore: (dynamic action) =>
                          onPlaylistMore!(action, playlistsData!),
                      contentId: playlistsData.id.toString(),
                      contentType: contentType,
                    )
                  : SizedBox();
            }
          },
          loaderItemsCount: 20,
        )
      : emptyBox(context!, msg: "No data available");
}
