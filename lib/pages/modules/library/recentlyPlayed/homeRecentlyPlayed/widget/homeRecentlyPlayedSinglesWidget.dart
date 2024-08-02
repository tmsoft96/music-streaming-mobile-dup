import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/models/recentlyPlayedSingleModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget homeRecentlyPlayedSinglesWidget({
  @required BuildContext? context,
  @required void Function()? onViewAllSongs,
  @required void Function(RecentlyPlayedSingleData data)? onTrack,
  @required void Function()? onPlayAll,
  @required RecentlyPlayedSingleModel? model,
  double divideWidth = .85,
}) {
  double width = MediaQuery.of(context!).size.width * divideWidth;
  return GestureDetector(
    onTap: onViewAllSongs,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 130,
          width: width,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 120,
                  width: width,
                  color: PRIMARYCOLOR1,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: onViewAllSongs,
                        child: Container(
                          width: width / 2.2,
                          height: 120,
                          child: Stack(
                            children: [
                              if (model!.data!.length >= 3)
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: cachedImage(
                                      context: context,
                                      image: model.data![2].thumb,
                                      height: 80,
                                      width: width / 2.9,
                                    ),
                                  ),
                                ),
                              if (model.data!.length >= 2)
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: cachedImage(
                                        context: context,
                                        image: model.data![1].thumb,
                                        height: 100,
                                        width: width / 2.8,
                                      ),
                                    ),
                                  ),
                                ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: cachedImage(
                                  context: context,
                                  image: model.data![0].thumb,
                                  height: 120,
                                  width: width / 2.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: width - (width / 2.2),
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int x = 0;
                                x <
                                    (model.data!.length >= 3
                                        ? 3
                                        : model.data!.length);
                                ++x)
                              GestureDetector(
                                onTap: () => onTrack!(model.data![x]),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  child: Text(
                                    "${x + 1}. ${model.data![x].title}",
                                    style: h6White,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: onPlayAll,
                  icon: Icon(
                    Icons.play_circle,
                    size: 40,
                    color: PRIMARYCOLOR,
                  ),
                ),
              ),
            ],
          ),
        ),
        Text("Last Played Songs", style: h6White),
      ],
    ),
  );
}
