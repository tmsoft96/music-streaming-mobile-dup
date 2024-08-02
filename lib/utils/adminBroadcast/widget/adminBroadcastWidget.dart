import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

import 'broadcastBottomWidget.dart';

Widget adminBroadcastWidget({
  @required BuildContext? context,
  @required void Function()? onRemove,
  @required TextEditingController? textController,
  @required FocusNode? textFocusNode,
  @required void Function()? onSend,
  @required void Function()? onPlay,
  @required PlayerModel? playerModel,
  @required bool? isPlaying,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Live Broadcast", style: h3BlackBold),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: BLACK,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: cachedImage(
                      context: context,
                      image: playerModel!.data![0].cover,
                      height: 80,
                      width: 80,
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: MediaQuery.of(context!).size.width * .63,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .63,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 3),
                              Text(
                                "${playerModel.data![0].title}",
                                style: h3BlackBold,
                              ),
                              SizedBox(height: 3),
                              Text("N/A listeners", style: h4White),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "${playerModel.data![0].description}",
              style: h5Black,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 180),
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * .35,
          // child: listenersWidget(
          //   context: context,
          //   onRemove: onRemove,
          // ),
          child: isPlaying!
              ? Image.asset(
                  LISTENING,
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * .35,
                )
              : SizedBox(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: BACKGROUND,
            height: MediaQuery.of(context).size.height * .35,
            child: broadcastBottomWidget(
              onSend: onSend,
              textController: textController,
              textFocusNode: textFocusNode,
              onPlay: onPlay,
              context: context,
              isPlaying: isPlaying,
            ),
          ),
        ),
      ],
    ),
  );
}
