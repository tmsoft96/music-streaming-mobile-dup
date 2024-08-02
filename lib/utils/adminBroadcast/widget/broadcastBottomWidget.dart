import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget broadcastBottomWidget({
  @required TextEditingController? textController,
  @required FocusNode? textFocusNode,
  @required void Function()? onSend,
  @required void Function()? onPlay,
  @required bool? isPlaying,
  @required BuildContext? context,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 10),
      // Text("Broadcast message to all listeners", style: h4BlackBold),
      // SizedBox(height: 10),
      // textFormField(
      //   hintText: "Enter Message",
      //   controller: textController,
      //   focusNode: textFocusNode,
      //   icon: Icons.send,
      //   iconColor: PRIMARYCOLOR,
      //   onIconTap: onSend,
      // ),
      // SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10.0, right: 15.0),
              child: Divider(color: PRIMARYCOLOR, thickness: 2),
            ),
          ),
          Text("LIVE", style: h4RedBold),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 15.0, right: 10.0),
              child: Divider(color: PRIMARYCOLOR, thickness: 2),
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      // Center(child: Text("10k listeners", style: h4BlackBold)),
      button(
        onPressed: onPlay,
        text: isPlaying! ? "End Broadcast" : "Join Braodcast",
        color: PRIMARYCOLOR,
        context: context,
      )
    ],
  );
}
