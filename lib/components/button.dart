import 'package:rally/spec/colors.dart';
import 'package:flutter/material.dart';

Widget button({
  @required void Function()? onPressed,
  void Function()? onLongPressed,
  @required String? text,
  @required Color? color,
  Color textColor = WHITE,
  bool colorFill = true,
  @required BuildContext? context,
  double divideWidth = 1.0,
  bool useWidth = true,
  double buttonRadius = 30,
  double height = 50,
  double elevation = .0,
  Color backgroundcolor = BACKGROUND,
  TextStyle? textStyle,
  Widget? icon,
  bool showBorder = true,
  EdgeInsetsGeometry? padding,
  bool centerItems = false,
  Widget? postFixIcon,
  bool useColumnIconType = false,
  bool useFittedText = false,
}) {
  return SizedBox(
    width: useWidth ? MediaQuery.of(context!).size.width * divideWidth : null,
    height: height,
    child: ElevatedButton(
      onPressed: onPressed,
      onLongPress: onLongPressed,
      child: icon == null && postFixIcon == null
          ? Text("$text", textAlign: TextAlign.center)
          : useColumnIconType
              ? Column(
                  mainAxisAlignment: centerItems
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    if (icon != null) icon,
                    if (text != null) ...[
                      SizedBox(height: 10),
                      useFittedText
                          ? FittedBox(
                              child: Text("$text", textAlign: TextAlign.center),
                            )
                          : Text("$text", textAlign: TextAlign.center),
                    ],
                    if (postFixIcon != null) ...[
                      SizedBox(height: 10),
                      postFixIcon,
                    ],
                  ],
                )
              : Row(
                  mainAxisAlignment: centerItems
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    if (icon != null) icon,
                    if (text != null) ...[
                      SizedBox(width: 10),
                      useFittedText
                          ? FittedBox(
                              child: Text("$text", textAlign: TextAlign.center),
                            )
                          : Text("$text", textAlign: TextAlign.center),
                    ],
                    if (postFixIcon != null) postFixIcon,
                  ],
                ),
      style: ElevatedButton.styleFrom(
        padding: padding,
        elevation: elevation,
        foregroundColor: textColor,
        backgroundColor: colorFill ? color : backgroundcolor,
        shape: showBorder
            ? RoundedRectangleBorder(
                side: BorderSide(color: color!),
                borderRadius: BorderRadius.circular(buttonRadius),
              )
            : null,
        textStyle: textStyle == null
            ? TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )
            : textStyle,
      ),
    ),
  );
}
