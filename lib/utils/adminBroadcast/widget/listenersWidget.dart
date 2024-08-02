import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget listenersWidget({
  @required BuildContext? context,
  @required void Function()? onRemove,
}) {
  return SingleChildScrollView(
    child: Wrap(
      spacing: 5,
      runSpacing: 5,
      children: [
        for (int x = 0; x < 50; ++x)
          Container(
            width: MediaQuery.of(context!).size.width * .22,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: BLACK,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                circular(
                  child: cachedImage(
                    context: context,
                    image: "",
                    height: 60,
                    width: 60,
                    placeholder: DEFAULTPROFILEPICOFFLINE,
                  ),
                  size: 60,
                ),
                SizedBox(height: 5),
                Text("Michael", style: h5BlackBold),
                SizedBox(height: 5),
                button(
                  onPressed: onRemove,
                  text: "Remove",
                  color: BLACK,
                  textColor: PRIMARYCOLOR,
                  context: context,
                  useWidth: false,
                  textStyle: h6Black,
                  height: 16,
                ),
              ],
            ),
          ),
      ],
    ),
  );
}
