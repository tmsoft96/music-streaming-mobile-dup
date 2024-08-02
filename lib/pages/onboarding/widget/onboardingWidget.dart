import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget onboardingWidget({
  @required BuildContext? context,
  @required void Function()? onLogin,
  @required void Function()? onGoogle,
  @required void Function()? onApple,
  @required void Function()? onRegister,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    width: double.maxFinite,
    alignment: Alignment.center,
    child: Stack(
      children: [
        // Align(
        //   alignment: Alignment.topRight,
        //   child: Image.asset(
        //     PHOTO2,
        //     height: MediaQuery.of(context!).size.height * .45,
        //   ),
        // ),
        Container(color: BACKGROUND.withOpacity(.9)),
        Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(LOGO, scale: 1.5),
              SizedBox(height: 20),
              Text(
                "The Hub for fresh music",
                style: h2WhiteBold,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 100),
              button(
                onPressed: onLogin,
                text: "LOGIN",
                color: PRIMARYCOLOR,
                context: context,
                height: 55,
                textStyle: h3BlackBold,
              ),
              SizedBox(height: 20),
              button(
                onPressed: onRegister,
                text: "Don't have an account? Sign up",
                color: BACKGROUND,
                context: context,
                textColor: PRIMARYCOLOR,
              ),
              SizedBox(height: 10),
              Text("or", style: h4WhiteBold),
              SizedBox(height: 10),
              button(
                onPressed: onGoogle,
                text: "Continue with Google",
                color: WHITE,
                context: context,
                icon: Image.asset(GOOGLE, scale: 1.6),
                textColor: BLACK,
                centerItems: true,
              ),
              if (Platform.isIOS) ...[
                SizedBox(height: 10),
                button(
                  onPressed: onApple,
                  text: "Continue with Apple",
                  color: WHITE,
                  context: context,
                  icon: Image.asset(iOS, scale: 1.6),
                  textColor: BLACK,
                  centerItems: true,
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}
