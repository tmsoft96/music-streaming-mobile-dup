import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/models/allArtistsModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget adminEnrollArtistWidget({
  @required BuildContext? context,
  @required void Function()? onEnroll,
  @required void Function()? onDecline,
  @required AllArtistData? allArtistData,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    alignment: Alignment.center,
    child: SingleChildScrollView(
      child: Column(
        children: [
          circular(
            child: cachedImage(
              context: context,
              image: "${allArtistData!.picture}",
              height: 150,
              width: 150,
              placeholder: DEFAULTPROFILEPICOFFLINE,
            ),
            size: 150,
          ),
          SizedBox(height: 30),
          Text(
            "${allArtistData.name} (${allArtistData.stageName ?? 'N/A'})",
            style: h3BlackBold,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text("${allArtistData.phone}", style: h5Black),
          SizedBox(height: 10),
          Text("${allArtistData.email}", style: h5Black),
          SizedBox(height: 30),
          button(
            onPressed: onEnroll,
            text: "Enroll",
            color: PRIMARYCOLOR,
            context: context,
          ),
          SizedBox(height: 10),
          button(
            onPressed: onDecline,
            text: "Decline",
            color: PRIMARYCOLOR.withOpacity(.4),
            context: context,
          ),
        ],
      ),
    ),
  );
}
