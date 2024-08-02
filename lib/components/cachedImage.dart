import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';

Widget cachedImage({
  @required BuildContext? context,
  @required String? image,
  @required double? height,
  @required double? width,
  String placeholder = NOAUDIOCOVER,
  BoxFit fit = BoxFit.cover,
  int? diskCache = 170,
}) {
  return CachedNetworkImage(
    height: height,
    width: width,
    fit: fit,
    maxHeightDiskCache: diskCache,
    maxWidthDiskCache: diskCache,
    errorWidget: (widget, text, error) {
      return Image.asset(
        placeholder,
        height: height,
        width: width,
        fit: fit,
      );
    },
    progressIndicatorBuilder: (context, url, progress) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (progress.progress != null && progress.progress! >= 0)
          SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(PRIMARYCOLOR),
              value: progress.progress,
            ),
          ),
        if (progress.progress == null || progress.progress! == 0)
          Image.asset(
            placeholder,
            width: width! - 13,
            height: height! - 13,
            color: PRIMARYCOLOR1,
          )
      ],
    ),
    imageUrl: "$image",
  );
}
