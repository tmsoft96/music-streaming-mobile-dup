import 'package:flutter/material.dart';
import 'package:rally/components/textField.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget uploadContent4Widget({
  @required BuildContext? context,
  @required void Function()? onPaste,
  @required void Function()? onAttach,
  @required void Function()? onClearAll,
  @required TextEditingController? lyricsController,
  @required FocusNode? lyricsFocusNode,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Add Lyrics (Optional)\nAttach only txt files",
                style: h6WhiteBold,
              ),
              SizedBox(width: 10),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: BLACK,
                    child: IconButton(
                      onPressed: onPaste,
                      icon: Icon(Icons.paste),
                      color: PRIMARYCOLOR,
                    ),
                  ),
                  SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: BLACK,
                    child: IconButton(
                      onPressed: onAttach,
                      icon: Icon(Icons.attach_file),
                      color: PRIMARYCOLOR,
                    ),
                  ),
                  SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: BLACK,
                    child: IconButton(
                      onPressed: onClearAll,
                      icon: Icon(Icons.clear),
                      color: PRIMARYCOLOR,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          textFormField(
            hintText: "Enter or upload lyrics",
            controller: lyricsController,
            focusNode: lyricsFocusNode,
            minLine: 30,
            maxLine: 30,
          ),
          SizedBox(height: 10),
        ],
      ),
    ),
  );
}
