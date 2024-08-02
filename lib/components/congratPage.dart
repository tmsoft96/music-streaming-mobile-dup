import 'package:flutter/material.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';

import 'button.dart';

class CongratPage extends StatelessWidget {
  final Widget? widget;
  final void Function(BuildContext context)? onHome;
  final bool? fillButtonColor;
  final String? homeButtonText;

  CongratPage({
    @required this.widget,
    @required this.onHome,
    @required this.fillButtonColor,
    this.homeButtonText = "HOME",
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(CORRECT, width: 300),
              SizedBox(height: 20),
              if (widget != null) widget!,
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: button(
            onPressed: () => onHome!(context),
            text: homeButtonText,
            color: fillButtonColor! ? PRIMARYCOLOR : BACKGROUND,
            context: context,
            textColor: fillButtonColor! ? BLACK : PRIMARYCOLOR,
            showBorder: fillButtonColor!,
          ),
        ),
      ),
    );
  }
}
