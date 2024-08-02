import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allFollowersModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget followedArtistsWidget({
  @required BuildContext? context,
  @required void Function(Data data)? onUser,
  @required void Function(Data data)? onUnfollow,
  @required AllFollowersModel? model,
}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(height: 10),
        if (model!.data!.length == 0)
          emptyBox(context!, msg: "No data available"),
        if (model.data!.length > 0)
          for (int x = 0; x < model.data!.length; ++x) ...[
            ListTile(
              tileColor: PRIMARYCOLOR1,
              minVerticalPadding: 20,
              onTap: () => onUser!(model.data![x]),
              leading: circular(
                child: cachedImage(
                  context: context,
                  image: "${model.data![x].user!.picture}",
                  height: 60,
                  width: 60,
                  placeholder: DEFAULTPROFILEPICOFFLINE,
                ),
                size: 60,
              ),
              title: Text(
                model.data![x].user!.stageName ?? model.data![x].user!.name,
                style: h4WhiteBold,
              ),
              subtitle: Row(
                children: [
                  Text(
                    "${getNumberFormat(int.parse(model.data![x].followersCount!))} Followers  -",
                    style: h6White,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.headphones, color: BLACK, size: 10),
                  SizedBox(width: 5),
                  Text(
                    "${getNumberFormat(int.parse(model.data![x].streamsCount!))}",
                    style: h6White,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              trailing: button(
                onPressed: () => onUnfollow!(model.data![x]),
                text: "Unfollow",
                color: TRANSPARENT,
                textColor: PRIMARYCOLOR,
                textStyle: h5BlackBold,
                context: context,
                useWidth: false,
              ),
            ),
            SizedBox(height: 10),
          ],
      ],
    ),
  );
}
