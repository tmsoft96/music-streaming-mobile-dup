import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget updateAppWidget({
  @required BuildContext? context,
  @required String? title,
  @required String? message,
  @required bool? allowNotNow,
  @required void Function()? onNotNow,
  @required void Function()? onUpdate,
}) {
  return Container(
    padding: EdgeInsets.all(10),
    child: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                UPDATE,
                height: MediaQuery.of(context!).size.height * .45,
              ),
              SizedBox(height: 20),
              Text("$title", style: h2WhiteBold),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "$message",
                  style: h5White,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              button(
                onPressed: onUpdate,
                text: "UPDATE APP",
                color: PRIMARYCOLOR,
                context: context,
              ),
              SizedBox(height: 10),
              if (allowNotNow!)
                button(
                  onPressed: onNotNow,
                  text: "Remind me later",
                  color: TRANSPARENT,
                  context: context,
                  textColor: PRIMARYCOLOR,
                  textStyle: h5Black,
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
