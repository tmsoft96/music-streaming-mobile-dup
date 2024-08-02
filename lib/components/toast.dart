import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:rally/spec/colors.dart';

void toastContainer({
  @required String? text,
  Toast toastLength = Toast.LENGTH_LONG,
  Color backgroundColor = WHITE,
}) {
  Fluttertoast.showToast(
    msg: text!,
    toastLength: toastLength,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: backgroundColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void toastContainer2({
  @required BuildContext? context,
  @required String? text,
  Color backgroundColor = WHITE,
}) {
  showToast(
    text,
    context: context,
    animation: StyledToastAnimation.slideFromBottomFade,
    reverseAnimation: StyledToastAnimation.slideToBottomFade,
    startOffset: Offset(0.0, 3.0),
    reverseEndOffset: Offset(0.0, 3.0),
    position: StyledToastPosition(align: Alignment.bottomCenter, offset: 0.5),
    duration: Duration(seconds: 4),
    //Animation duration   animDuration * 2 <= duration
    animDuration: Duration(milliseconds: 400),
    curve: Curves.linearToEaseOut,
    reverseCurve: Curves.fastOutSlowIn,
    backgroundColor: backgroundColor,
    fullWidth: true,
  );
}
