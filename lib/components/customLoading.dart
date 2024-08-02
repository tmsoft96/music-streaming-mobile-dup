import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

import 'loadingView.dart';

Widget customLoadingPage({
  String msg = "",
  void Function()? onClose,
  double? percent,
  String? percentBottomText = "Please wait",
}) {
  double? percentage;
  if (percent != null) percentage = (percent / 100) * 1;

  return Scaffold(
    backgroundColor: BACKGROUND.withOpacity(.8),
    body: Stack(
      children: [
        Container(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (percent == null) ...[
                  loadingFadingCircle(PRIMARYCOLOR, size: 70),
                  if (msg != "") ...[
                    SizedBox(height: 40),
                    Center(
                      child: Text(
                        "$msg",
                        style: h5WhiteBold,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
                if (percent != null) ...[
                  CircularPercentIndicator(
                    radius: 60,
                    lineWidth: 13,
                    percent: percentage!,
                    center: Text("$msg", style: h5WhiteBold),
                    progressColor: PRIMARYCOLOR,
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      "$percentBottomText",
                      style: h5WhiteBold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                //   if (onClose == null) ...[
                //     SizedBox(height: 10),
                //     TextButton(
                //       onPressed: onClose,
                //       child: Text(
                //         "Cancel",
                //         style: h4BlackBold,
                //       ),
                //     ),
                //   ],
              ],
            ),
          ),
        ),
        // if (showClose)
        //   Align(
        //     alignment: Alignment.topRight,
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: CircleAvatar(
        //         backgroundColor: BLACK,
        //         child: IconButton(
        //           onPressed: onClose,
        //           color: WHITE,
        //           icon: Icon(Icons.close),
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    ),
  );
}
