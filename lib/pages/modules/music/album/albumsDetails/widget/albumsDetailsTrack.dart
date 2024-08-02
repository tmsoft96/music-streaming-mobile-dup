import 'package:flutter/material.dart';
import 'package:rally/components/contentDisplayDetails.dart';
import 'package:rally/models/allAlbumModel.dart';
import 'package:rally/models/allMusicModel.dart';

Widget albumsDetailsTrack({
  @required void Function(AllMusicData data)? onTrack,
  @required void Function()? onSingleDownload,
  @required void Function(ContentFile file)? onAlbumTrack,
  @required void Function(ContentFile file)? onAlbumDownload,
  @required void Function(dynamic action, ContentFile file)? onAlbumTrackMore,
  @required BuildContext? context,
  @required AllMusicData? allMusicData,
  @required AllAlbumData? allAlbumData,
  @required void Function(dynamic action)? onSingleTrackMore,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 10),
      if (allMusicData != null) ...[
        contentDisplayDetails(
          context: context,
          onTrack: () => onTrack!(allMusicData),
          artistName: allMusicData.stageName,
          cover: allMusicData.media!.thumb,
          onDownloadTrack: onSingleDownload,
          onTrackMore: (dynamic action) => onSingleTrackMore!(action),
          title: allMusicData.title,
          contentId: allMusicData.id.toString(),
          contentType: 'single',
        ),
        SizedBox(height: 30),
      ],
      if (allAlbumData != null && allAlbumData.files != null)
        for (var data in allAlbumData.files!) ...[
          contentDisplayDetails(
            context: context,
            onTrack: () => onAlbumTrack!(data),
            artistName: allAlbumData.stageName,
            cover: allAlbumData.media!.thumb,
            onDownloadTrack: () => onAlbumDownload!(data),
            onTrackMore: (dynamic action) => onAlbumTrackMore!(action, data),
            title: data.name,
            contentId: data.id.toString(),
            contentType: 'single',
          ),
          SizedBox(height: 10),
        ],
    ],
  );
}
