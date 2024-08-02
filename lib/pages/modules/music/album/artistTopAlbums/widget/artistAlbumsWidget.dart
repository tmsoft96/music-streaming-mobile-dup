import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/contentDisplayHome1.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/models/allAlbumModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget artistAlbumsWidget({
  @required BuildContext? context,
  @required void Function()? onSeeAll,
  @required void Function(AllAlbumData data)? onAlbum,
  @required void Function(AllAlbumData data)? onAlbumMore,
  @required void Function(AllAlbumData data)? onPlayAlbum,
  @required AllAlbumModel? model,
  @required String? artistName,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text("Albums by $artistName", style: h5White)),
            button(
              onPressed: onSeeAll,
              text: 'More >',
              color: BACKGROUND,
              context: context,
              useWidth: false,
              textColor: PRIMARYCOLOR,
            ),
          ],
        ),
      ),
      if (model!.data!.length == 0)
        emptyBoxLinear(context!, msg: "No album available"),
      if (model.data!.length > 0)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: model.data!.length,
            separatorBuilder: (_, int index) => SizedBox(width: 10),
            itemBuilder: (BuildContext context, int index) => contentDisplayHome1(
              context: context,
              contentImage: model.data![index].media!.thumb,
              onContent: () => onAlbum!(model.data![index]),
              onContentMore: () => onAlbumMore!(model.data![index]),
              streamNumber: null,
              title: "${model.data![index].name}",
              stageName: "${model.data![index].stageName}",
              onPlayContent: () => () => onPlayAlbum!(model.data![index]),
            ),
          ),
        ),
    ],
  );
}
