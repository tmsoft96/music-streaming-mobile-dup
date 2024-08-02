import 'package:rally/components/ratingStar.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

Widget podcastRatingReview({
  @required BuildContext? context,
  @required void Function(double rating)? onRating,
  @required void Function()? onWriteReview,
  @required AllRadioData? data,
}) {
  return Container(
    color: BLACK,
    padding: EdgeInsets.all(5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Rating & Reviews", style: h5Black),
        SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context!).size.width * .3,
              child: Column(
                children: [
                  Text(
                    data!.totalRate! > .0 ? "${data.totalRate!}" : "N/A",
                    style: h1BlackBold,
                  ),
                  SizedBox(height: 10),
                  Text("${data.ratings!.length} total", style: h5Black),
                ],
              ),
            ),
            SizedBox(width: 5),
            Container(
              width: MediaQuery.of(context).size.width * .6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _rateBar(
                    value: ((data.fiveRate! / 5) * 100).round(),
                    color: GREEN,
                    rateNumber: "5",
                    context: context,
                  ),
                  _rateBar(
                    value: ((data.fourRate! / 4) * 100).round(),
                    color: GREEN.withOpacity(.7),
                    rateNumber: "4",
                    context: context,
                  ),
                  _rateBar(
                    value: ((data.threeRate! / 3) * 100).round(),
                    color: YELLOW.shade300,
                    rateNumber: "3",
                    context: context,
                  ),
                  _rateBar(
                    value: ((data.twoRate! / 2) * 100).round(),
                    color: YELLOW,
                    rateNumber: "2",
                    context: context,
                  ),
                  _rateBar(
                    value: ((data.oneRate! / 1) * 100).round(),
                    color: RED.shade100,
                    rateNumber: "1",
                    context: context,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text("Rate : ", style: h4White),
            SizedBox(width: 5),
            ratingStar(
              function: (double rating) => onRating!(rating),
              rate: data.currentListenerRate,
            ),
          ],
        ),
        SizedBox(height: 10),
        // button(
        //   onPressed: onWriteReview,
        //   text: "Write a Review",
        //   color: WHITE,
        //   context: context,
        //   textColor: PRIMARYCOLOR,
        //   icon: Icon(FeatherIcons.edit, color: PRIMARYCOLOR),
        //   textStyle: h5BlackBold,
        // ),
      ],
    ),
  );
}

Widget _rateBar({
  @required int? value,
  @required Color? color,
  @required String? rateNumber,
  @required BuildContext? context,
}) {
  return Row(
    children: [
      Container(
        width: MediaQuery.of(context!).size.width * .02,
        alignment: Alignment.center,
        child: Text("$rateNumber", style: h5Black),
      ),
      SizedBox(width: 10),
      Container(
        width: MediaQuery.of(context).size.width * .55,
        child: FAProgressBar(
          currentValue: value! == 0 ? 2 : value.toDouble(),
          displayText: null,
          size: 10,
          backgroundColor: BLACK,
          progressColor: color!,
        ),
      ),
    ],
  );
}
