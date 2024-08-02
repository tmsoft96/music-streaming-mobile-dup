import 'package:flutter/material.dart';
import 'package:rally/components/toggleBar.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/pages/modules/library/download/downloadTap/downloadAlbum/downloadAlbum/downloadAlbum.dart';
import 'package:rally/pages/modules/library/download/downloadTap/downloadArtists/dowloadArtists/downloadArtists.dart';
import 'package:rally/pages/modules/library/download/downloadTap/downloadSongs/downloadSongs.dart';
import 'package:rally/spec/arrays.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget downloadLibraryWidget({
  @required void Function(int index)? onTap,
  @required int? tabIndex,
  @required AllDownloadModel? model,
}) {
  return Stack(
    children: [
      ToggleBar(
        labels: downloadLibraryList,
        selectedTabColor: PRIMARYCOLOR1,
        backgroundColor: TRANSPARENT,
        textColor: BLACK,
        selectedTextColor: BLACK,
        onSelectionUpdated: (index) => onTap!(index),
        labelTextStyle: h5BlackBold,
      ),
      Container(
        margin: EdgeInsets.only(top: 50),
        child: tabIndex == 0
            ? DownloadSongs(model)
            : tabIndex == 1
                ? DownloadArtists(model)
                : DownloadAlbum(model),
      ),
    ],
  );
}
