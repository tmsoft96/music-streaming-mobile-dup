import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:rally/components/button.dart';
import 'package:rally/spec/colors.dart';

Widget uploadOption({
  @required BuildContext? context,
  @required void Function()? onAudioSelection,
  @required void Function()? onVideoSelection,
  @required void Function()? onOtherSelection,
}) {
  return SafeArea(
    child: Container(
      padding: EdgeInsets.all(10),
      color: BACKGROUND,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          button(
            onPressed: () {
              Navigator.pop(context!);
              onAudioSelection!();
            },
            text: Platform.isAndroid ? "Music" : "Apple Music",
            color: BLACK,
            context: context,
            textColor: PRIMARYCOLOR,
            icon: Icon(Icons.audio_file_outlined, color: PRIMARYCOLOR),
            centerItems: true,
            elevation: 5,
          ),
          SizedBox(height: 10),
          // button(
          //   onPressed: () {
          //     Navigator.pop(context!);
          //     onVideoSelection!();
          //   },
          //   text: "Video",
          //   color: WHITE,
          //   context: context,
          //   textColor: PRIMARYCOLOR,
          //   icon: Icon(Icons.video_file_outlined, color: PRIMARYCOLOR),
          //   centerItems: true,
          //   elevation: 5,
          // ),
          // SizedBox(height: 10),
          button(
            onPressed: () {
              Navigator.pop(context!);
              onOtherSelection!();
            },
            text: "Files",
            color: BLACK,
            context: context,
            textColor: PRIMARYCOLOR,
            icon: Icon(FeatherIcons.folder, color: PRIMARYCOLOR),
            centerItems: true,
            elevation: 5,
          ),
          SizedBox(height: 10),
          button(
            onPressed: () => Navigator.pop(context!),
            text: "Cancel",
            color: RED,
            context: context,
          ),
        ],
      ),
    ),
  );
}
