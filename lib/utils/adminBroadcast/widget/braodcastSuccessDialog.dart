import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget braodcastSuccessDialog({
  @required BuildContext? context,
  @required void Function()? onPlay,
  @required void Function()? onSubmitHome,
}) {
  return Dialog(
    child: Container(
      color: BLACK,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(CORRECT),
          SizedBox(height: 10),
          Text(
            "Braodcast ended",
            style: h3BlackBold,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          button(
            onPressed: onPlay,
            text: "Play Broadcast",
            color: BLACK,
            textColor: PRIMARYCOLOR,
            context: context,
          ),
          SizedBox(height: 20),
          button(
            onPressed: onSubmitHome,
            text: "Sumbit and go home",
            color: PRIMARYCOLOR,
            context: context,
          ),
        ],
      ),
    ),
  );
}
