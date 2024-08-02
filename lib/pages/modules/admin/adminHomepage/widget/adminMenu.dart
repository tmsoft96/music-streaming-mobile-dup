import 'package:flutter/material.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget adminMenu({
  @required void Function()? onRadio,
  @required void Function()? onArtist,
  @required void Function()? onUsers,
  @required void Function()? onLogs,
  @required void Function()? onBanner,
}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        _button(
          onMenu: onBanner,
          text: "Banners",
          image: BANNER,
        ),
        SizedBox(width: 6),
        _button(
          onMenu: onRadio,
          text: "Radio",
          image: ADMINRADIO,
        ),
        SizedBox(width: 6),
        _button(
          onMenu: onArtist,
          text: "Artists",
          image: ADMINARTISTS,
        ),
        SizedBox(width: 6),
        _button(
          onMenu: onUsers,
          text: "Regular Users",
          image: ADMINUSERS,
        ),
        SizedBox(width: 6),
        _button(
          onMenu: onLogs,
          text: "Logs",
          image: ADMINS,
        ),
      ],
    ),
  );
}

Widget _button({
  @required void Function()? onMenu,
  @required String? text,
  @required String? image,
}) {
  return GestureDetector(
    onTap: onMenu,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 150,
        height: 100,
        child: Stack(
          children: [
            Image.asset(
              image!,
              height: 100,
              width: 150,
              fit: BoxFit.cover,
            ),
            Container(
              width: 150,
              height: 100,
              color: PRIMARYCOLOR.withOpacity(.5),
            ),
            Center(child: Text("$text", style: h4BlackBold)),
          ],
        ),
      ),
    ),
  );
}
