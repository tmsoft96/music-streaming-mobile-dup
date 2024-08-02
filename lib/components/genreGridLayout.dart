import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget genreGridLayout({
  @required BuildContext? context,
  @required String? image,
  @required String? title,
  @required void Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 100,
        height: 80,
        child: Stack(
          children: [
            Blur(
              blur: 5,
              blurColor: BACKGROUND,
              child: cachedImage(
                context: context,
                image: image,
                height: 80,
                width: 100,
                placeholder: NOAUDIOCOVER,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text("$title", style: h6WhiteBold),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: cachedImage(
                  context: context,
                  image: image,
                  height: 50,
                  width: 60,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
