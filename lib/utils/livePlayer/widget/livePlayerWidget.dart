import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget livePlayerWidget({
  @required BuildContext? context,
  @required void Function()? onPlay,
  @required bool? isPlaying,
  @required PlayerModel? playerModel,
}) {
  return Container(
    margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      color: BLACK,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    child: Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 7,
            width: MediaQuery.of(context!).size.width * .4,
            decoration: BoxDecoration(
              color: ASHDEEP,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.only(top: 40),
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * .62,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: cachedImage(
                    context: context,
                    image: playerModel!.data![0].cover,
                    height: MediaQuery.of(context).size.height * .4,
                    width: MediaQuery.of(context).size.width * .8,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text("${playerModel.data![0].title}", style: h3BlackBold),
              SizedBox(height: 10),
              Text(
                "${playerModel.data![0].description}",
                style: h5Black,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0, right: 15.0),
                    child: Divider(color: PRIMARYCOLOR, thickness: 2),
                  ),
                ),
                Text("LIVE", style: h4RedBold),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 15.0, right: 10.0),
                    child: Divider(color: PRIMARYCOLOR, thickness: 2),
                  ),
                ),
              ]),
              SizedBox(height: 10),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 10),
              //   child: Text("10k listeners", style: h4BlackBold),
              // ),
              SizedBox(height: 10),
              button(
                onPressed: onPlay,
                text: isPlaying! ? "End Broadcast" : "Join Braodcast",
                color: PRIMARYCOLOR,
                context: context,
              )
            ],
          ),
        ),
      ],
    ),
  );
}
