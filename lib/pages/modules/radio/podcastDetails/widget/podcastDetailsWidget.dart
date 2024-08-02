import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/pages/modules/radio/morePodcast/morePodcast.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

import 'podcastRatingReview.dart';
import 'podcastPopup.dart';

Widget podcastDetailsWidget({
  @required BuildContext? context,
  @required void Function()? onPlay,
  @required void Function()? onMoreDescription,
  @required void Function(double rating)? onRating,
  @required void Function()? onWriteReview,
  @required void Function()? onBack,
  @required void Function(String action)? onMorePopUp,
  @required AllRadioData? data,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context!).size.height * .43,
          child: Stack(
            children: [
              cachedImage(
                context: context,
                image: data!.cover,
                height: MediaQuery.of(context).size.height * .4,
                width: double.maxFinite,
                placeholder: NOAUDIOCOVER,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 90),
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${data.title}", style: h3WhiteBoldShadow),
                    SizedBox(height: 10),
                    Text("${data.stageName}", style: h5WhiteBoldShadow),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: button(
                  onPressed: onPlay,
                  text: "PLAY",
                  color: PRIMARYCOLOR,
                  context: context,
                  divideWidth: .6,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: PRIMARYCOLOR,
                        child: IconButton(
                          onPressed: onBack,
                          icon: Icon(Icons.arrow_back),
                          color: BLACK,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: PRIMARYCOLOR,
                        child: podcastPopup(
                          onAction: (String action) => onMorePopUp!(action),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${getNumberFormat(data.streams!.length)} listeners",
                style: h5BlackBold,
              ),
              SizedBox(height: 10),
              Wrap(
                children: [
                  Text(
                    "${data.description}",
                    style: h5Black,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  button(
                    onPressed: onMoreDescription,
                    text: "See More",
                    color: BACKGROUND,
                    context: context,
                    textColor: PRIMARYCOLOR,
                    textStyle: h5BlackBold,
                    useWidth: false,
                    padding: EdgeInsets.zero,
                    height: 30,
                  ),
                ],
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    Icon(Icons.watch_later_outlined, color: PRIMARYCOLOR),
                    SizedBox(width: 10),
                    Text(
                      " ${data.startDate!.split(' ')[1].substring(0, 5)}",
                      style: h5BlackBold,
                    ),
                  ],
                ),
                trailing: Text(
                  "${getReaderDate(data.startDate!.split(' ')[0])}",
                  style: h5BlackBold,
                ),
              ),
              Text("Hosts", style: h4BlackBold),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // for (int x = 0; x < 6; ++x) ...[
                    Container(
                      width: 120,
                      child: Column(
                        children: [
                          circular(
                            child: cachedImage(
                              context: context,
                              image: "${data.user!.picture}",
                              height: 70,
                              width: 70,
                              placeholder: DEFAULTPROFILEPICOFFLINE,
                            ),
                            size: 70,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "${data.user!.name}",
                            style: h5BlackBold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text("Host", style: h6Black),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    // ],
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        podcastRatingReview(
          context: context,
          onRating: (double rating) => onRating!(rating),
          onWriteReview: () => onWriteReview!(),
          data: data,
        ),
        SizedBox(height: 10),
        MorePodcast(),
        SizedBox(height: 10),
      ],
    ),
  );
}
