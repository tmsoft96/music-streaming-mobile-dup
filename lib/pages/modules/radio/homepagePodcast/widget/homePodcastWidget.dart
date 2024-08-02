import 'package:flutter/material.dart';
import 'package:rally/components/textField.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/pages/modules/radio/morePodcast/morePodcast.dart';
import 'package:rally/pages/modules/radio/topRadioShow/topPodcastShow.dart';
import 'package:rally/pages/modules/radio/upcomingBroadcast/upcomingBroadcast.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget homePodcastWidget({
  @required void Function()? onSearch,
  bool fromAdminPage = false,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!fromAdminPage)
                Text(
                  "Hi ${userModel!.data!.user!.fname!} 👋",
                  style: h5WhiteBold,
                ),
              SizedBox(height: 10),
              Text("Explore Podcast", style: h3WhiteBold),
              SizedBox(height: 10),
              Card(
                elevation: 4,
                child: GestureDetector(
                  onTap: onSearch,
                  child: textFormField(
                    hintText: "Search",
                    controller: null,
                    focusNode: null,
                    removeBorder: true,
                    prefixIcon: Icons.search,
                    prefixIconColor: ASHDEEP,
                    enable: false,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        UpcomingBroadcast(),
        SizedBox(height: 10),
        TopPodcastShow(),
        SizedBox(height: 10),
        MorePodcast(),
        SizedBox(height: 10),
      ],
    ),
  );
}
