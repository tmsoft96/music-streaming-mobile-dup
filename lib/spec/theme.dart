import 'package:flutter/material.dart';

import 'colors.dart';
import 'styles.dart';

ThemeData theme() {
  return ThemeData(
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: h4White,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(35),
          ),
        ),
        side: BorderSide(color: GREY),
      ),
    ),
    scaffoldBackgroundColor: BACKGROUND,
    primaryColor: BLACK,
    disabledColor: ASHDEEP,
    appBarTheme: AppBarTheme(
      backgroundColor: BACKGROUND,
      elevation: .0,
      centerTitle: true,
      iconTheme: IconThemeData(color: BLACK),
      actionsIconTheme: IconThemeData(color: BLACK),
      titleTextStyle: h4White,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: PRIMARYCOLOR,
      foregroundColor: WHITE,
    ),
  );
}

ThemeData datePickerTheme() {
  return ThemeData.light().copyWith(
    colorScheme: ColorScheme.light(primary: PRIMARYCOLOR),
  );
}
