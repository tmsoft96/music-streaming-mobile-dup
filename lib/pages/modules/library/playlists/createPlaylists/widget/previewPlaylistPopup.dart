import 'package:flutter/material.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

PopupMenuButton previewPlaylistPopup({
  @required void Function(String action)? onAction,
}) {
  return PopupMenuButton(
    color: PRIMARYCOLOR1,
    icon: Icon(Icons.more_vert, color: BLACK),
    itemBuilder: (BuildContext bc) => [
      PopupMenuItem(child: Text("Edit", style: h6White), value: "ed"),
      PopupMenuItem(child: Text("Delete", style: h6White), value: "dl"),
    ],
    onSelected: (route) => onAction!(route),
  );
}
