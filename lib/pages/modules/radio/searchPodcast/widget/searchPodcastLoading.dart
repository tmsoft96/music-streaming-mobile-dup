import 'package:flutter/material.dart';
import 'package:rally/components/loadingView.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget searchLoading(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    height: MediaQuery.of(context).size.height * .8,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        loadingFoldingCube(PRIMARYCOLOR),
        SizedBox(height: 30),
        Text(
          "Add more characters to make search easier",
          style: h4White,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
