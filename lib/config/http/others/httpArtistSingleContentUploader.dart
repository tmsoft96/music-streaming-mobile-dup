import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/services.dart';

typedef void OnUploadProgressCallBack(int sentBytes, int totalBytes);

Future<void> httpArtistSingleContentUploader({
  @required Map<String, dynamic>? meta,
  @required void Function(Map<String, dynamic>? data)? onFunction,
  @required OnUploadProgressCallBack? onUploadProgress,
}) async {
  String url = "https://$BASE_URL$SUBBASE_URL$POSTMUSIC_URL";

  File contentCover = File(meta!["contentCover"]);
  File content = meta["contents"][0];

  FormData formData = FormData.fromMap({
    "userid": meta["artistId"].toString(),
    "title": meta["title"].trimRight(),
    "filepath": "",
    "cover_filepath": "",
    "stage_name": meta["stageName"].trimRight(),
    "lyrics": meta["lyrics"],
    "genre": json.encode([meta["genreId"]]),
    "tags": json.encode(meta["tags"]),
    "description": meta["description"].trimRight(),
    "album_id": meta["albumId"] ?? "",
    "status": (meta["publicationStatusIndex"] ?? 0).toString(),
    "createuser": userModel!.data!.user!.userid!,
    "cover": await MultipartFile.fromFile(
      contentCover.path,
      filename: basename(contentCover.path),
    ),
    "file": await MultipartFile.fromFile(
      content.path,
      filename: basename(content.path),
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
      "error": "Error uploading file, Status code: ${response.statusCode}",
      "value": "",
    });
  }
}
