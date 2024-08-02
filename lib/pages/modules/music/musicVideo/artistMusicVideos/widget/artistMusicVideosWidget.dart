import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget artistMusicVideosWidget({
  @required BuildContext? context,
  @required void Function()? onSeeAll,
  @required void Function(AllMusicData data)? onContent,
  @required AllMusicModel? model,
  @required String? artistName,
}) {
  bool isShow = false;
  for (int x = 0; x < model!.data!.length; ++x)
    if (model.data![x].filepath!.split("/").last.contains("mp4")) {
      isShow = true;
      break;
    }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Videos by $artistName", style: h4White),
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
      ),
      if (!isShow) emptyBoxLinear(context!, msg: "No video available"),
      if (isShow)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: 10),
              for (var data in model.data!)
                if (data.filepath!.split("/").last.contains("mp4")) ...[
                  GestureDetector(
                    onTap: () => onContent!(data),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: BLACK,
                        constraints: BoxConstraints(minHeight: 175),
                        width: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cachedImage(
                              context: context,
                              image: data.cover,
                              height: 100,
                              width: 120,
                              placeholder: NOAUDIOCOVER,
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              child: Text(
                                "${data.title}",
                                style: h5BlackBold,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 3),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              child: Text(
                                "${data.stageName}",
                                style: h6Black,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              SizedBox(width: 10),
            ],
          ),
        ),
    ],
  );
}
