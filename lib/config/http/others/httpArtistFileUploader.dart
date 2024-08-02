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

Future<void> httpArtistFileUploader({
  @required Map<String, dynamic>? meta,
  @required void Function(Map<String, dynamic>? data)? onFunction,
}) async {
  var uri = Uri.parse("https://$BASE_URL$SUBBASE_URL$FILEUPLOAD_URL");
  var request = new http.MultipartRequest("POST", uri);

  request.fields.addAll({
    "userid": meta!["artistId"].toString(),
    "title": meta["title"].trimRight(),
    "createuser": userModel!.data!.user!.userid!,
    "folder_id": "",
    //  "genre[0]": meta["genreId"].toString(),
  });

  // File file = File(meta["contentCover"]);
  // var stream =
  //     // ignore: deprecated_member_use
  //     new http.ByteStream(DelegatingStream.typed(file.openRead()));
  // var length = await file.length();

  // var multipartFile = new http.MultipartFile(
  //   "cover",
  //   stream,
  //   length,
  //   filename: basename(file.path),
  // );
  // request.files.add(multipartFile);

  if (meta["contents"] != null) {
    File file = meta["contents"][0];

    var multipartFile = new http.MultipartFile(
      "files",
      file.readAsBytes().asStream(),
      file.lengthSync(),
      filename: basename(file.path),
    );
    request.files.add(multipartFile);
  }

  print(request.files[0].filename);

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
