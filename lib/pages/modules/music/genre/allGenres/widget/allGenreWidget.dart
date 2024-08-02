import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget allGenreWidget({
  @required BuildContext? context,
  @required void Function()? onGenre,
}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(height: 10),
        for (int x = 0; x < 8; ++x) ...[
          ListTile(
            onTap: onGenre,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: cachedImage(
                context: context,
                image: RADIOCOVER,
                height: 60,
                width: 60,
              ),
            ),
            title: Text("All Genres", style: h4BlackBold),
            trailing: Icon(Icons.check, color: WHITE),
          ),
          SizedBox(height: 10),
        ],
      ],
    ),
  );
}
