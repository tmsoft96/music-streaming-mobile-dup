import 'package:flutter/material.dart';
import 'package:rally/components/toggleBar.dart';
import 'package:rally/pages/modules/admin/artist/adminViewAllArtist/approvedArtist/approvedArtist.dart';
import 'package:rally/pages/modules/admin/artist/adminViewAllArtist/declinedArtist/declinedArtist.dart';
import 'package:rally/pages/modules/admin/artist/adminViewAllArtist/pendingArtist/pendingArtist.dart';
import 'package:rally/spec/arrays.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget adminViewAllArtistWidget({
  @required BuildContext? context,
  @required int? tabIndex,
  @required void Function(int index)? onTap,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Stack(
      children: [
        Container(
          height: 60,
          margin: EdgeInsets.only(top: 10),
          color: BACKGROUND,
          child: ToggleBar(
            labels: statusList,
            selectedTabColor: PRIMARYCOLOR,
            backgroundColor: PRIMARYCOLOR1,
            textColor: BLACK,
            selectedTextColor: BLACK,
            onSelectionUpdated: (index) => onTap!(index),
            labelTextStyle: h5BlackBold,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 80),
          child: tabIndex == 0
              ? ApprovedArtist()
              : tabIndex == 1
                  ? PendingArtist()
                  : DeclinedArtist(),
        ),
      ],
    ),
  );
}
