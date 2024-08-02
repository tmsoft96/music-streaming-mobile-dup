import 'package:rally/components/button.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';
import 'package:flutter/material.dart';

Widget introduceFriendWidget({
  @required void Function()? onInvite,
  @required BuildContext? context,
}) {
  return Container(
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: PRIMARYCOLOR1,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Text(
          "Invite friends",
          style: h4WhiteBold,
        ),
        SizedBox(height: 10),
        Text(
          "Introduce your friends to discover your music, favorite radio and many more",
          style: h6White,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        button(
          onPressed: onInvite,
          text: "Invite Friends",
          color: PRIMARYCOLOR,
          context: context,
        ),
      ],
    ),
  );
}
