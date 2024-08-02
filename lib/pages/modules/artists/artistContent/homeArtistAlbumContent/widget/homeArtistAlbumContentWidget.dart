import 'package:flutter/material.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/components/toggleBar.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/models/allAlbumModel.dart';
import 'package:rally/spec/arrays.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

import '../../../../../../components/contentDisplayAlbum.dart';

Widget homeArtistAlbumContentWidget({
  @required BuildContext? context,
  @required int? noOfContentDisplay,
  @required void Function(AllAlbumData data)? onAlbum,
  @required void Function(AllAlbumData data)? onAlbumMore,
  @required void Function(AllAlbumData data)? onPlayAlbum,
  @required AllAlbumModel? model,
  @required void Function(int index)? onTap,
  @required int? tabIndex,
  @required String? artistId,
}) {
  int maxNum = model!.data!.length > 5 ? 5 : model.data!.length;
  return Column(
    children: [
      if (noOfContentDisplay == -1000 &&
          userModel!.data!.user!.userid == artistId) ...[
        ToggleBar(
          labels: albumPublicationTabList,
          selectedTabColor: PRIMARYCOLOR.withOpacity(.7),
          backgroundColor: BACKGROUND,
          textColor: BLACK,
          selectedTextColor: WHITE,
          onSelectionUpdated: (index) => onTap!(index),
          labelTextStyle: h5BlackBold,
        ),
        SizedBox(height: 10),
      ],
      if (model.data!.length == 0)
        noOfContentDisplay == -1000
            ? emptyBox(context!, msg: "No album content available")
            : emptyBoxLinear(context!, msg: "No album content available"),
      if (noOfContentDisplay != null &&
          noOfContentDisplay != -1000 &&
          model.data!.length > 0)
        contentDisplayAlbum(
          context: context,
          image: model.data![0].media!.thumb,
          title: model.data![0].name,
          isPublic: model.data![0].public == "0",
          noOfFiles: model.data![0].files!.length,
          showBanner: false,
          onContentMore: () => onAlbumMore!(model.data![0]),
          artistName: model.data![0].stageName,
          onContent: () => onAlbum!(model.data![0]),
          onPlayContent: () => onPlayAlbum!(model.data![0]),
        ),
      if (noOfContentDisplay == null)
        for (int x = 0; x < maxNum; ++x)
          contentDisplayAlbum(
            context: context,
            image: model.data![x].media!.thumb,
            title: model.data![x].name,
            isPublic: model.data![x].public == "0",
            noOfFiles: model.data![x].files!.length,
            showBanner: false,
            onContentMore: () => onAlbumMore!(model.data![x]),
            artistName: model.data![x].stageName,
            onContent: () => onAlbum!(model.data![x]),
            onPlayContent: () => onPlayAlbum!(model.data![x]),
            subtractWidth: 50,
          ),
      if (noOfContentDisplay == -1000)
        for (int x = 0; x < model.data!.length; ++x)
          GestureDetector(
            onTap: () => onAlbum!(model.data![x]),
            child: contentDisplayAlbum(
              context: context,
              image: model.data![x].media!.thumb,
              title: model.data![x].name,
              isPublic: model.data![x].public == "0",
              noOfFiles: model.data![x].files!.length,
              showBanner:
                  userModel!.data!.user!.userid == model.data![x].userid,
              onContentMore: () => onAlbumMore!(model.data![x]),
              artistName: model.data![x].stageName,
              onContent: () => onAlbum!(model.data![x]),
              onPlayContent: () => onPlayAlbum!(model.data![x]),
            ),
          ),
    ],
  );
}
