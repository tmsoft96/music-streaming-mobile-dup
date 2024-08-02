import 'package:flutter/material.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

PopupMenuButton podcastPopup({
  @required void Function(String action)? onAction,
}) {
  return PopupMenuButton(
    color: PRIMARYCOLOR1,
    icon: Icon(Icons.more_vert, color: BLACK),
    itemBuilder: (BuildContext bc) => [
      PopupMenuItem(child: Text("Report", style: h6White), value: "rc"),
    ],
    onSelected: (route) => onAction!(route),
  );
}
