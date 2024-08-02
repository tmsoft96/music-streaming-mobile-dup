import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget homeRecentlyAlbum({
  @required BuildContext? context,
  @required void Function()? onAlbumPlayAll,
  @required void Function()? onAlbumDetails,
  @required String? image,
  @required String? title,
  double height = 130,
  double width = 120,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: onAlbumDetails,
        child: Container(
          height: height,
          width: width,
          child: Stack(
            children: [
              Container(
                height: height - 10,
                width: width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: cachedImage(
                    context: context,
                    image: image,
                    height: height - 10,
                    width: width,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: onAlbumPlayAll,
                  icon: Icon(
                    Icons.play_circle,
                    size: 40,
                    color: PRIMARYCOLOR,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Text("$title", style: h6White, overflow: TextOverflow.ellipsis),
    ],
  );
}
