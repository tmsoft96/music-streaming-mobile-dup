import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/services.dart';
import 'package:rally/spec/strings.dart';

Future<void> httpCreateBanner({
  @required Map<String, dynamic>? meta,
  @required void Function(Map<String, dynamic>? data)? onFunction,
}) async {
  var uri = meta!["bannerId"] == null
      ? Uri.parse("https://$BASE_URL$SUBBASE_URL$CREATEBANNER_URL")
      : Uri.parse("https://$BASE_URL$SUBBASE_URL$UPDATEBANNER_URL");
  var request = new http.MultipartRequest("POST", uri);

  meta["bannerId"] == null
      ? request.fields.addAll({
          "posts": meta["posts"],
          "title": meta["title"].trimRight(),
          "createuser": userModel!.data!.user!.userid!,
        })
      : request.fields.addAll({
          "posts": meta["posts"],
          "title": meta["title"].trimRight(),
          "createuser": userModel!.data!.user!.userid!,
          "bannerID": meta["bannerId"].toString(),
        });

  File file = File(meta["cover"]);

  var multipartFile = new http.MultipartFile(
    "cover",
    file.readAsBytes().asStream(),
    file.lengthSync(),
    filename: basename(file.path),
  );
  request.files.add(multipartFile);

  request.headers.addAll({
    // "Authorization": "Bearer ${userModel!.data!.token}",
    "Content-Type": "multipart/form-data",
  });

  var response = await request.send();
  response.stream.bytesToString().then((value) async {
    log(value);
    try {
      final decodeData = json.decode(value);
      onFunction!(decodeData);
    } catch (e) {
      onFunction!({"ok": false, "msg": REQUESTERROR});
    }
  });
}
