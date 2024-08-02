import 'package:flutter/material.dart';
import 'package:rally/spec/colors.dart';

Widget circular({
  @required Widget? child,
  @required double? size,
  Color borderColor = ASHDEEP,
}) {
  return ClipOval(
    child: Container(
      height: size,
      width: size,
      child: child,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
      ),
    ),
  );
}
