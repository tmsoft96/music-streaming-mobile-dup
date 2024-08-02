import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/components/ratingStar.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/pages/modules/music/commentSection/commentSection.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

Widget albumsDetailsReviews({
  @required BuildContext? context,
  @required void Function(double rating)? onRating,
  @required void Function()? onComment,
  @required AllMusicData? allMusicData,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Ratings and Comments", style: h5WhiteBold),
      SizedBox(height: 10),
      Row(
        children: [
          Container(
            width: MediaQuery.of(context!).size.width * .3,
            child: Column(
              children: [
                Text(
                  allMusicData!.totalRate! > .0
                      ? "${allMusicData.totalRate!.toStringAsFixed(1)}"
                      : "N/A",
                  style: h1WhiteBold,
                ),
                SizedBox(height: 10),
                Text(
                  "${allMusicData.ratings!.length} total",
                  style: h6White,
                ),
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
                  value: ((allMusicData.fiveRate! / 5) * 100).round(),
                  color: GREEN,
                  rateNumber: "5",
                  context: context,
                ),
                _rateBar(
                  value: ((allMusicData.fourRate! / 4) * 100).round(),
                  color: GREEN.withOpacity(.7),
                  rateNumber: "4",
                  context: context,
                ),
                _rateBar(
                  value: ((allMusicData.threeRate! / 3) * 100).round(),
                  color: YELLOW.shade300,
                  rateNumber: "3",
                  context: context,
                ),
                _rateBar(
                  value: ((allMusicData.twoRate! / 2) * 100).round(),
                  color: YELLOW,
                  rateNumber: "2",
                  context: context,
                ),
                _rateBar(
                  value: ((allMusicData.oneRate! / 1) * 100).round(),
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
            rate: allMusicData.currentListenerRate,
          ),
        ],
      ),
      SizedBox(height: 10),
      Text("Comments", style: h5WhiteBold),
      SizedBox(height: 10),
      GestureDetector(
        onTap: onComment,
        child: Container(
          color: TRANSPARENT,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              circular(
                child: cachedImage(
                  context: context,
                  image: userModel!.data!.user!.picture!,
                  height: 40,
                  width: 40,
                ),
                size: 40,
              ),
              SizedBox(width: 10),
              Text("Add a comment...", style: h6White),
            ],
          ),
        ),
      ),
      Divider(color: BLACK),
      SizedBox(height: 10),
      CommentSection(
        showAppbar: false,
        contentId: allMusicData.id.toString(),
      ),
    ],
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
        child: Text("$rateNumber", style: h6White),
      ),
      SizedBox(width: 10),
      Container(
        width: MediaQuery.of(context).size.width * .55,
        child: FAProgressBar(
          currentValue: value! == 0 ? 2 : value.toDouble(),
          displayText: null,
          size: 10,
          backgroundColor: BACKGROUND,
          progressColor: color!,
        ),
      ),
    ],
  );
}
