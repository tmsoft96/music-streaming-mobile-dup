import 'package:flutter/material.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/pages/modules/radio/homepagePodcast/widget/homePodcastWidget.dart';

import 'radioAnalysis.dart';

Widget adminPodcastWidget({
  @required BuildContext? context,
  @required void Function()? onSearch,
  @required AllPodcastModel? model,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        podcastAnalysis(context: context, model: model),
        SizedBox(height: 10),
        homePodcastWidget(
          onSearch: onSearch,
          fromAdminPage: true,
        ),
      ],
    ),
  );
}
