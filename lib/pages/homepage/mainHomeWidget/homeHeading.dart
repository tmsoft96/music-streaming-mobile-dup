import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/spec/arrays.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

AppBar homeHeading({
  @required BuildContext? context,
  @required void Function()? onGenre,
  @required void Function()? onNotification,
  @required void Function()? onDashboard,
  @required void Function()? onAccount,
  @required String? title,
}) {
  return AppBar(
    titleTextStyle: h2WhiteBold,
    centerTitle: false,
    title: Row(
      children: [
        Image.asset(APPICON, width: 40),
        SizedBox(width: 5),
        Text("$title"),
      ],
    ),
    actions: [
      if (userModel!.data!.user!.role!.toLowerCase() != userTypeList[0])
        IconButton(
          onPressed: onDashboard,
          iconSize: 46,
          icon: Image.asset(DASHBOARDICON, width: 46, height: 46),
        ),
      SizedBox(width: 5),
      // IconButton(
      //   onPressed: onNotification,
      //   iconSize: 26,
      //   icon: Icon(FeatherIcons.bell),
      // ),
      // SizedBox(width: 5),
      GestureDetector(
        onTap: onAccount,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: circular(
            child: cachedImage(
              context: context,
              image: "${userModel!.data!.user!.picture!}",
              height: 32,
              width: 32,
              placeholder: DEFAULTPROFILEPICOFFLINE,
            ),
            size: 32,
          ),
        ),
      ),
    ],
  );
}
