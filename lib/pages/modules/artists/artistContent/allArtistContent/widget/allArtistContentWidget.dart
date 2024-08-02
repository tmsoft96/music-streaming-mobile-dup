import 'package:flutter/material.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/toggleBar.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/pages/modules/artists/artistContent/homeArtistAlbumContent/homeArtistAlbumContent.dart';
import 'package:rally/components/contentDisplayFull.dart';
import 'package:rally/pages/modules/artists/artistContent/homeArtistVideoContent/homeArtistVideoContent.dart';
import 'package:rally/spec/arrays.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget allArtistContentWidget({
  @required BuildContext? context,
  @required void Function(AllMusicData data)? onContent,
  @required void Function(AllMusicData data)? onContentMore,
  @required void Function(AllMusicData data)? onContentPlay,
  @required AllMusicModel? model,
  @required void Function(int index)? onTap,
  @required int? tabIndex,
  @required String? artistId,
}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(height: 10),
        ToggleBar(
          labels: artistHomepageTabList,
          selectedTabColor: PRIMARYCOLOR,
          backgroundColor: PRIMARYCOLOR1,
          textColor: BLACK,
          selectedTextColor: WHITE,
          onSelectionUpdated: (index) => onTap!(index),
          labelTextStyle: h5BlackBold,
        ),
        SizedBox(height: 10),
        if (tabIndex == 0) ...[
          if (model!.data!.length == 0)
            emptyBox(context!, msg: "No audio content available"),
          for (int x = 0; x < model.data!.length; ++x)
            if (!model.data![x].filepath!.split("/").last.contains("mp4"))
              contentDisplayFull(
                context: context,
                image: model.data![x].media!.thumb,
                streamNumber: model.data![x].streams!.length,
                title: model.data![x].title,
                onContentMore: () => onContentMore!(model.data![x]),
                onContentPlay: () => onContentPlay!(model.data![x]),
                artistName: model.data![x].stageName,
                onContent: () => onContent!(model.data![x]),
              ),
        ],
        if (tabIndex == 1)
          HomeArtistAlbumContent(
            noOfContentDisplay: -1000,
            artistId: artistId,
          ),
        if (tabIndex == 2)
          HomeArtistVideoContent(
            noOfContentDisplay: -1000,
            artistId: artistId,
          ),
      ],
    ),
  );
}
