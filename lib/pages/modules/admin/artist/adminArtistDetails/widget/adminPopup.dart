import 'package:flutter/material.dart';

PopupMenuButton adminPopup({
  @required void Function(String action)? onAction,
}) {
  return PopupMenuButton(
    itemBuilder: (BuildContext bc) => [
      PopupMenuItem(child: Text("Reset Password"), value: "rs"),
      PopupMenuItem(child: Text("Edit Profile"), value: "ep"),
      PopupMenuItem(child: Text("Decline Artist"), value: "ds"),
      PopupMenuItem(child: Text("Switch to User"), value: "stu"),
      PopupMenuItem(child: Text("Disable Account"), value: "da"),
    ],
    onSelected: (route) => onAction!(route),
  );
}
