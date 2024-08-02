import 'package:flutter/material.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget emptyBoxLinear(BuildContext context, {String msg = ""}) {
  return Container(
    margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.symmetric(vertical: 20),
    height: 120,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: BACKGROUND,
      boxShadow: [
        BoxShadow(
          color: WHITE.withOpacity(.1),
          spreadRadius: .1,
          blurRadius: 20,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Stack(
      children: [
        // Align(
        //   alignment: Alignment.bottomRight,
        //   child: Image.asset(
        //     PHOTO2,
        //     width: 120,
        //     height: 120,
        //     fit: BoxFit.cover,
        //   ),
        // ),
        Container(color: BACKGROUND.withOpacity(.6)),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Image.asset(
            EMPTYBIG,
            width: 100,
            height: 100,
          ),
          title: Text("$msg", style: h4WhiteBold),
        ),
      ],
    ),
  );
}
