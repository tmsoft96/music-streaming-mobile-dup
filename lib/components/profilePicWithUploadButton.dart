import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';

import 'cachedImage.dart';
import 'circular.dart';

Widget profilePicWithUploadButton({
  @required BuildContext? context,
  @required String? profilePicture,
  @required void Function()? onUpload,
}) {
  return Container(
    height: 170,
    child: Stack(
      children: [
        Center(
          child: circular(
            child: cachedImage(
              context: context,
              image: profilePicture,
              height: 150,
              width: 150,
              placeholder: DEFAULTPROFILEPICOFFLINE,
            ),
            size: 150,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 80),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: CircleAvatar(
              backgroundColor: PRIMARYCOLOR,
              child: IconButton(
                onPressed: onUpload,
                color: WHITE,
                icon: Icon(
                  FeatherIcons.edit,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
