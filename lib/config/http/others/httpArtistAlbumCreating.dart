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

Future<void> httpArtistAlbumCreating({
  @required Map<String, dynamic>? meta,
  @required void Function(Map<String, dynamic>? data)? onFunction,
}) async {
  var uri = Uri.parse("https://$BASE_URL$SUBBASE_URL$CREATEALBUM_URL");
  var request = new http.MultipartRequest("POST", uri);

  request.fields.addAll({
    "userid": meta!["artistId"].toString(),
    "name": meta["title"].trimRight(),
    "tags": json.encode(meta["tags"]),
    "description": meta["description"].trimRight(),
    "createuser": userModel!.data!.user!.userid!,
    "status": meta["albumPublicationIndex"].toString(),
    "stage_name": meta["stageName"].trimRight(),
  });

  File file = File(meta["contentCover"]);

  var multipartFile = new http.MultipartFile(
    "cover",
    file.readAsBytes().asStream(),
    file.lengthSync(),
    filename: basename(file.path),
  );
  request.files.add(multipartFile);

  request.headers.addAll({
    "Authorization": "Bearer ${userModel!.data!.token}",
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
