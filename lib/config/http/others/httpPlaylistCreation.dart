import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/services.dart';

typedef void OnUploadProgressCallBack(int sentBytes, int totalBytes);

Future<void> httpPlaylistCreation({
  @required Map<String, dynamic>? meta,
  @required void Function(Map<String, dynamic>? data)? onFunction,
  @required OnUploadProgressCallBack? onUploadProgress,
}) async {
  String url = meta!["playlistId"] == null
      ? "https://$BASE_URL$SUBBASE_URL$PLAYLISTS_URL"
      : "https://$BASE_URL$SUBBASE_URL$UPDATECONTENTPLAYLISTS_URL";

  File contentCover = File(meta["cover"]);

  FormData formData = FormData.fromMap({
    "id": meta["playlistId"],
    "userid": userModel!.data!.user!.userid!,
    "title": meta["title"].trimRight(),
    "description": meta["description"].trimRight(),
    "genres": json.encode([meta["genre"]]),
    "content": json.encode(meta["content"]),
    "type": "0", // 0 = song, 1 = podcast, 2 = video
    "status": (meta["permission"] ?? 0).toString(),
    "cover": await MultipartFile.fromFile(
      contentCover.path,
      filename: basename(contentCover.path),
    ),
  });

  Dio dio = new Dio();
  Response response = await dio.post(
    url,
    data: formData,
    onSendProgress: (int sent, int total) {
      onUploadProgress!(sent, total);
    },
  );

  if (response.statusCode == 200) {
    final decodeData = json.decode(response.toString());
    onFunction!(decodeData);
  } else {
    onFunction!({
      "ok": false,
      "error": "Error creating playlist, Status code: ${response.statusCode}",
      "value": "",
    });
  }
}
