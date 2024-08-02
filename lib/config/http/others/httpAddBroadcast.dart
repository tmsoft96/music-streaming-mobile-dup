import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/services.dart';
import 'package:rally/spec/strings.dart';

Future<void> httpAddBroadcast({
  @required Map<String, dynamic>? meta,
  @required void Function(Map<String, dynamic>? data)? onFunction,
}) async {
  var uri = meta!["isUpdate"]
      ? Uri.parse("https://$BASE_URL$SUBBASE_URL$UPDATEPODCAST_URL")
      : Uri.parse("https://$BASE_URL$SUBBASE_URL$PODCASTS_URL");
  var request = new http.MultipartRequest("POST", uri);

  request.fields.addAll(meta["isUpdate"]
      ? {
          "postID": meta["postId"].toString(),
          "userid": userModel!.data!.user!.userid!,
          "title": meta["title"].trimRight(),
          "filepath": meta["isLocalContent"] ? "" : meta["editContentPath"],
          "cover_filepath": meta["isLocalImage"] ? "" : meta["cover"],
          "start_date": meta["dateTime"],
          "status": meta["status"].toString(),
          "tags": json.encode(meta["tags"]),
          "description": meta["description"].trimRight(),
          "stage_name": userModel!.data!.user!.name!,
          "timezone": meta["timezone"],
        }
      : {
          "userid": userModel!.data!.user!.userid!,
          "title": meta["title"].trimRight(),
          "filepath": "",
          "cover_filepath": "",
          "start_date": meta["dateTime"],
          "status": meta["status"].toString(),
          "tags": json.encode(meta["tags"]),
          "description": meta["description"].trimRight(),
          "stage_name": userModel!.data!.user!.name!,
          "timezone": meta["timezone"],
        });

  print(request.fields);

  if (meta["isLocalImage"]) {
    File file = File(meta["cover"]);
    var stream =
        // ignore: deprecated_member_use
        new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();

    var multipartFile = new http.MultipartFile(
      "cover",
      stream,
      length,
      filename: basename(file.path),
    );
    request.files.add(multipartFile);
  }

  if (meta["status"] == "0" &&
      meta["contents"] != null &&
      meta["isLocalContent"]) {
    File file = meta["contents"][0];

    var multipartFile = new http.MultipartFile(
      "file",
      file.readAsBytes().asStream(),
      file.lengthSync(),
      filename: basename(file.path),
    );
    request.files.add(multipartFile);
  }

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
