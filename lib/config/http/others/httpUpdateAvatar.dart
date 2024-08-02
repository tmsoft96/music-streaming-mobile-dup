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

Future<void> httpUpdateAvatar({
  @required File? avatar,
  @required void Function(Map<String, dynamic>? data)? onFunction,
}) async {
  var uri = Uri.parse("https://$BASE_URL$SUBBASE_URL$UPDATEAVATAR_URL");
  var request = new http.MultipartRequest("POST", uri);

  request.fields.addAll({"userid": userModel!.data!.user!.userid!});

  if (avatar != null) {
    var multipartFile = new http.MultipartFile(
      "avatar",
      avatar.readAsBytes().asStream(),
      avatar.lengthSync(),
      filename: basename(avatar.path),
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
