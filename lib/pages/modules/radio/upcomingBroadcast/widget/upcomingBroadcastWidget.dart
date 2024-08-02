import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget upcomingBroadcastWidget({
  @required BuildContext? context,
  @required void Function(AllRadioData data)? onBroadcast,
  @required AllPodcastModel? model,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Text("Up Next", style: h5WhiteBold),
      ),
      SizedBox(height: 10),
      if (model!.data!.length == 0)
        emptyBoxLinear(context!, msg: "No upcoming show"),
      if (model.data!.length > 0)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: 15),
              for (var data in model.data!) ...[
                GestureDetector(
                  onTap: () => onBroadcast!(data),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 200,
                      height: 287,
                      color: BACKGROUND,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 190,
                            width: 200,
                            child: Stack(
                              children: [
                                cachedImage(
                                  context: context,
                                  image: "${data.cover}",
                                  height: 170,
                                  width: 200,
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 10),
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    Icons.play_circle,
                                    color: PRIMARYCOLOR,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${data.title}",
                                  style: h3WhiteBold,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "${data.description}",
                                  style: h6White,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
              ],
              SizedBox(width: 15),
            ],
          ),
        ),
    ],
  );
}
