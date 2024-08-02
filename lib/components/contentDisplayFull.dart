import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget contentDisplayFull({
  @required BuildContext? context,
  @required String? image,
  @required String? title,
  @required String? artistName,
  @required int? streamNumber,
  @required void Function()? onContent,
  @required void Function()? onContentPlay,
  @required void Function()? onContentMore,
  int subtractWidth = 0,
  bool isDownload = false,
  double? downloadPercentComplete,
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
                  if (streamNumber != null) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.headphones, color: BLACK, size: 20),
                        SizedBox(width: 5),
                        Text(getNumberFormat(streamNumber), style: h7WhiteBold),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isDownload)
                  IconButton(
                    icon: Icon(
                      Icons.play_circle,
                      color: PRIMARYCOLOR,
                    ),
                    onPressed: onContentPlay,
                  ),
                if (isDownload)
                  CircularProgressIndicator(
                    backgroundColor: PRIMARYCOLOR1,
                    valueColor: new AlwaysStoppedAnimation<Color>(PRIMARYCOLOR),
                    value: downloadPercentComplete! / 100,
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
