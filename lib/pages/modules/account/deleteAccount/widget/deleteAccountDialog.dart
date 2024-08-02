import 'package:flutter/material.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget deleteAccountDialog({
  @required void Function()? onCancel,
  @required void Function()? onDelete,
}) {
  return AlertDialog(
    contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    title: Text(
      'Are you sure you want to delete your account?',
      textAlign: TextAlign.center,
    ),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SimpleDialogOption(
          child: Text(
            'If you delete your account, you will permanently lose your profile, content, and photos. If you delete your account, this action cannot be undone.',
            style: h4Black,
            textAlign: TextAlign.center,
          ),
        ),
        SimpleDialogOption(
          child: Text(
            'Are you sure you want to delete your account?',
            style: h4Black,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        style: TextButton.styleFrom(foregroundColor: WHITE),
        onPressed: onCancel,
        child: Text('CANCEL'),
      ),
      TextButton(
        style: TextButton.styleFrom(
          foregroundColor: BLACK,
          backgroundColor: RED,
        ),
        onPressed: onDelete,
        child: Text('DELETE'),
      ),
    ],
  );
}
