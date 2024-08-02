import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allArtistsModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget allArtistsWidget({
  @required BuildContext? context,
  @required void Function(AllArtistData data)? onArtist,
  @required AllArtistsModel? model,
  @required void Function()? onSeeAll,
  @required bool? showNextSet,
}) {
  int notNextSetLen = model!.data!.length >= 7 ? 7 : model.data!.length;
  int nextSetLen = model.data!.length >= 14 ? 14 : notNextSetLen;
  int maxLen = !showNextSet! ? notNextSetLen : nextSetLen;
  int startInc = !showNextSet
      ? 0
      : model.data!.length >= 14
          ? 7
          : 0;

  List<AllArtistData> allArtistList = [
    for (int x = startInc; x < maxLen; ++x) model.data![x]
  ];

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Trending Artists", style: h4White),
                SizedBox(height: 5),
                Text(
                  "Most popular artist in the region.",
                  style: h7White,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          button(
            onPressed: onSeeAll,
            text: 'More >',
            color: BACKGROUND,
            context: context,
            useWidth: false,
            textColor: PRIMARYCOLOR,
          ),
        ],
      ),
      SizedBox(height: 10),
      model.data!.length == 0
          ? shimmerItem(useGrid: true)
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              height: 160,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  separatorBuilder: (_, int index) => SizedBox(width: 10),
                  itemBuilder: (BuildContext context, int x) {
                    return x < 0
                        ? SizedBox()
                        : Container(
                            width: 110,
                            child: GestureDetector(
                              onTap: () => onArtist!(allArtistList[x]),
                              child: Column(
                                children: [
                                  circular(
                                    child: cachedImage(
                                      context: context,
                                      image: "${allArtistList[x].picture}",
                                      height: 100,
                                      width: 100,
                                      placeholder: DEFAULTPROFILEPICOFFLINE,
                                    ),
                                    size: 100,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "${allArtistList[x].stageName ?? allArtistList[x].name}",
                                    style: h6WhiteBold,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "${getNumberFormat(int.parse(allArtistList[x].followersCount!))} Followers  -",
                                          style: h7White,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.headphones,
                                          color: BLACK,
                                          size: 10,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "${getNumberFormat(int.parse(allArtistList[x].streamsCount!))}",
                                          style: h7White,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                  }),
            ),
    ],
  );
}
