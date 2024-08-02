import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget contentDisplayAlbum({
  @required BuildContext? context,
  @required String? image,
  @required String? title,
  @required String? artistName,
  @required int? noOfFiles,
  @required bool? showBanner,
  @required bool? isPublic,
  @required void Function()? onContentMore,
  @required void Function()? onContent,
  @required void Function()? onPlayContent,
  int subtractWidth = 0,
}) {
  return GestureDetector(
    onTap: onContent,
    onLongPress: onContentMore ?? null,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.all(10),
        color: TRANSPARENT,
        width: double.maxFinite,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: WHITE,
                child: cachedImage(
                  context: context,
                  image: image,
                  height: 80,
                  width: 80,
                  placeholder: NOAUDIOCOVER,
                  diskCache: 150,
                ),
              ),
            ),
            SizedBox(width: 10),
            Container(
              width: (MediaQuery.of(context!).size.width - subtractWidth) * .46,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 3),
                  Text(
                    "$title",
                    style: h5WhiteBold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "$artistName",
                    style: h6White,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.music_note, color: BLACK, size: 20),
                      SizedBox(width: 5),
                      Text("$noOfFiles song(s)", style: h7WhiteBold),
                    ],
                  ),
                  if (showBanner!) ...[
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: isPublic! ? GREEN : RED,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isPublic ? "Publish" : "Not Publish",
                            style: h6BlackBold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.play_circle,
                    color: PRIMARYCOLOR,
                  ),
                  onPressed: onPlayContent,
                ),
                if (onContentMore != null)
                  IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: BLACK,
                    ),
                    onPressed: onContentMore,
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
