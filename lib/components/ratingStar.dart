import 'package:rally/spec/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Widget ratingStar({
  @required double? rate,
  @required void Function(double rating)? function,
  double size = 40,
  bool ignore = false,
}) {
  return RatingBar.builder(
    initialRating: rate!,
    minRating: 1,
    direction: Axis.horizontal,
    itemSize: size,
    itemCount: 5,
    unratedColor: BLACK.withOpacity(0.2),
    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
    itemBuilder: (context, _) => Icon(
      Icons.star,
      color: PRIMARYCOLOR,
    ),
    onRatingUpdate: (double rating) => function!(rating),
    glow: true,
    glowColor: RED,
    ignoreGestures: ignore,
  );
}
