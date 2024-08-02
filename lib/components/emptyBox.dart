import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';

Widget emptyBox(
  BuildContext context, {
  String msg = "",
  void Function()? onTap,
  String? buttonText,
}) {
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child: SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(EMPTYBIG),
          SizedBox(height: 20),
          Center(
            child: Text(
              "Oops, Nothing Here !\n $msg",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 17,
                color: BLACK,
              ),
            ),
          ),
          if (onTap != null) ...[
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: button(
                onPressed: onTap,
                text: "$buttonText",
                color: PRIMARYCOLOR,
                context: context,
              ),
            )
          ],
        ],
      ),
    ),
  );
}
