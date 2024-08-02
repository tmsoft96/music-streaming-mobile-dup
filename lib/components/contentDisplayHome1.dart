import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget contentDisplayHome1({
  @required BuildContext? context,
  @required String? contentImage,
  @required String? streamNumber,
  @required String? title,
  @required String? stageName,
  @required void Function()? onContent,
  @required void Function()? onContentMore,
  @required void Function()? onPlayContent,
}) {
  return GestureDetector(
    onTap: onContent,
    onLongPress: onContentMore,
    child: Container(
      width: 150,
      height: 170,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: WHITE,
                      child: cachedImage(
                        image: contentImage,
                        height: 130,
                        width: 150,
                        placeholder: NOAUDIOCOVER,
                        context: context,
                      ),
                    ),
                  ),
                  if (streamNumber != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: PRIMARYCOLOR1.withOpacity(.8),
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.headphones, color: BLACK, size: 20),
                            SizedBox(width: 5),
                            Text(getNumberFormat(int.parse(streamNumber)),
                                style: h7WhiteBold),
                          ],
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: onContentMore,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          color: PRIMARYCOLOR1.withOpacity(.8),
                          child: Icon(
                            Icons.more_vert,
                            color: BLACK,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Container(
                    width: 150 - 23,
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title!,
                          style: h6WhiteBold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3),
                        Text(
                          stageName!,
                          style: h7White,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              child: GestureDetector(
                onTap: onPlayContent,
                child: Icon(
                  Icons.play_circle,
                  color: PRIMARYCOLOR,
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
