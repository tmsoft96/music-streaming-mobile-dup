import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget contentDisplayHome2({
  @required BuildContext? context,
  @required String? contentImage,
  @required String? title,
  @required String? artistName,
  @required int? streamNumber,
  @required void Function()? onContentMore,
  @required void Function()? onContent,
  @required void Function()? onPlayContent,
}) {
  return GestureDetector(
    onTap: onContent,
    onLongPress: onContentMore,
    child: Container(
      color: TRANSPARENT,
      width: 320,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: WHITE,
              child: cachedImage(
                context: context,
                image: contentImage,
                height: 80,
                width: 80,
                placeholder: NOAUDIOCOVER,
              ),
            ),
          ),
          SizedBox(width: 5),
          Container(
            width: 320 - 90,
            child: Row(
              children: [
                Container(
                  width: 320 - 135,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3),
                      Text(
                        title!,
                        style: h6WhiteBold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3),
                      Text(artistName!, style: h7White),
                      SizedBox(height: 3),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.headphones, color: BLACK, size: 20),
                          SizedBox(width: 5),
                          Text(
                            getNumberFormat(streamNumber!),
                            style: h7WhiteBold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: onPlayContent,
                  child: Icon(
                    Icons.play_circle,
                    size: 30,
                    color: PRIMARYCOLOR,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
