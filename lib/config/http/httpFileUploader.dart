import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'dart:developer';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services.dart';

List<String> allFileUrl = [];

Future<void> httpFileUploader({
  @required List<String>? imageList,
  @required void Function()? onFunction,
  String fieldName = "file",
  String endpoint = "$PICTUREUPLOAD_URL",
}) async {
  allFileUrl.clear();
  for (int x = 0; x < imageList!.length; ++x) {
    File imagePath = File(imageList[x]);
    var stream =
        // ignore: deprecated_member_use
        new http.ByteStream(DelegatingStream.typed(imagePath.openRead()));
    var length = await imagePath.length();

    var uri = Uri.parse("https://$BASE_URL$SUBBASE_URL$endpoint");

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile(
      fieldName,
      stream,
      length,
      filename: basename(imagePath.path),
    );

    // request.headers.addAll({"Authorization": AuthenticationHeader});
    request.files.add(multipartFile);
    var response = await request.send();
    response.stream.bytesToString().then((value) async {
      print(value);
      final decodeData = json.decode(value);
      if (decodeData['ok'] == true) {
        String imageLink = decodeData["data"];
        print(imageLink);
        allFileUrl += [imageLink];
        if (imageList.length == allFileUrl.length) {
          log(allFileUrl.toString());
          onFunction!();
        }
      } else {
        print("Error occurred while uploading image");
      }
    });
  }
}
