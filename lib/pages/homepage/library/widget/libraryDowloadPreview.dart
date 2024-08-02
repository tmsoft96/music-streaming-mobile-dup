import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget libraryDowloadPreview({
  @required BuildContext? context,
  @required void Function()? onShowDownload,
  @required String? image,
  @required List<String>? contentTitle,
}) {
 List<String> titleList = contentTitle!.reversed.toList();
  return GestureDetector(
    onTap: onShowDownload,
    child: Container(
      height: 110,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Blur(
                  blur: 25,
                  blurColor: BACKGROUND,
                  child: cachedImage(
                    context: context,
                    image: image,
                    height: 105,
                    width: double.maxFinite,
                    placeholder: NOAUDIOCOVER,
                  ),
                ),
                Container(color: BACKGROUND.withOpacity(.5)),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: cachedImage(
                          context: context,
                          image: image,
                          height: 80,
                          width: 80,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: MediaQuery.of(context!).size.width * .6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int x = 0; x < titleList.length; ++x) ...[
                              Text(
                                "${x + 1} ${titleList[x]}",
                                style: h6White,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.play_circle,
              color: PRIMARYCOLOR,
              size: 40,
            ),
          ),
        ],
      ),
    ),
  );
}
