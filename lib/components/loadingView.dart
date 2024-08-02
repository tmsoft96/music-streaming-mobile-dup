// Progress indicator widget to show loading.
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loadingFoldingCube(Color color) => Center(
      child: SpinKitFoldingCube(
        color: color,
      ),
    );

Widget loadingDoubleBounce(Color color, {double size = 50}) => Center(
      child: SpinKitDoubleBounce(
        color: color,
        size: size,
      ),
    );

Widget loadingThreeBounce(Color color) => Center(
      child: SpinKitThreeBounce(
        size: 20.0,
        color: color,
      ),
    );

Widget loadingPumpingHeart(Color color) => Center(
      child: SpinKitPumpingHeart(
        size: 25,
        color: color,
      ),
    );

Widget loadingFadingCircle(Color color, {double size = 50}) => Center(
      child: SpinKitFadingCircle(
        color: color,
        size: size,
      ),
    );
