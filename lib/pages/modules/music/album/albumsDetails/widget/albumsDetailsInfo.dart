import 'package:flutter/material.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allAlbumModel.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/spec/styles.dart';

Widget albumsDetailsInfo({
  @required AllMusicData? allMusicData,
  @required AllAlbumData? allAlbumData,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (allAlbumData != null)
        ListTile(
          visualDensity: VisualDensity(vertical: -3),
          dense: true,
          title: Text("Album", style: h6WhiteBold),
          subtitle: Text(
              "${allAlbumData.name} - ${allAlbumData.files == null ? 'N/A' : allAlbumData.files!.length} Song",
              style: h6White),
        ),
      if (allMusicData != null)
        ListTile(
          visualDensity: VisualDensity(vertical: -3),
          dense: true,
          title: Text("Title", style: h6WhiteBold),
          subtitle: Text("${allMusicData.title} - ${allMusicData.stageName}",
              style: h6White),
        ),
      ListTile(
        visualDensity: VisualDensity(vertical: -3),
        dense: true,
        title: Text("Release Date", style: h6WhiteBold),
        subtitle: Text(
            "${getReaderDate(allMusicData != null ? allMusicData.createdAt! : allAlbumData!.createdAt!)}",
            style: h6White),
      ),
      if (allMusicData != null)
        ListTile(
          visualDensity: VisualDensity(vertical: -3),
          dense: true,
          title: Text("Genre", style: h5WhiteBold),
          subtitle: Text("${allMusicData.allGenresName}", style: h6White),
        ),
      if ((allAlbumData != null &&
              allAlbumData.description != null &&
              allAlbumData.description != "") ||
          (allMusicData != null &&
              allMusicData.description != null &&
              allMusicData.description != ""))
        ListTile(
          visualDensity: VisualDensity(vertical: -3),
          dense: true,
          title: Text("Description", style: h6WhiteBold),
          subtitle: Text(
            allAlbumData != null
                ? allAlbumData.description!
                : allMusicData!.description!,
            style: h6White,
          ),
        ),
    ],
  );
}
