import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/spec/styles.dart';

Widget adminUpcomingRadioDetailsWidget({
  @required BuildContext? context,
  @required AllRadioData? data,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cachedImage(
          context: context,
          image: data!.cover,
          height: 250,
          width: double.maxFinite,
        ),
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Time: ${data.startDate!.split(' ')[1]}",
                style: h5White,
              ),
              Text(
                "${getReaderDate(data.startDate!.split(' ')[0])}",
                style: h5White,
              ),
            ],
          ),
          subtitle: Text("${data.title}", style: h4WhiteBold),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(data.description ?? 'N/A', style: h5White),
        ),
      ],
    ),
  );
}
