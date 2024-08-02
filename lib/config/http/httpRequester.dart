import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../checkSession.dart';
import '../services.dart';

enum HTTPMETHOD { POST, GET }

Future<Map<String, dynamic>> httpRequesting({
  @required String? endPoint,
  @required HTTPMETHOD? method,
  Map<String, dynamic>? httpPostBody,
  String? tempHeader,
  bool showLog = false,
}) async {
  if (showLog) {
    print("endpoint $endPoint");
    print("httpbody $httpPostBody");
  }
  Uri uri = Uri.https(BASE_URL, "$SUBBASE_URL$endPoint");
  final response = method == HTTPMETHOD.GET
      ? await http
          .get(
            uri,
            headers: userModel == null
                ? null
                : {"Authorization": "Bearer ${userModel!.data!.token}"},
          )
          .timeout(Duration(minutes: 5))
      : await http
          .post(
            uri,
            headers: tempHeader != null
                ? {"Authorization": "Bearer $tempHeader"}
                : userModel == null
                    ? null
                    : {"Authorization": "Bearer ${userModel!.data!.token}"},
            body: httpPostBody,
          )
          .timeout(Duration(minutes: 5));

  String data = utf8.decode(response.bodyBytes);

  if (showLog)
    log({
      "endpoint": endPoint,
      "httpbody": httpPostBody,
      "statusCode": response.statusCode.toString(),
      "data": data,
    }.toString());

  final responseData = json.decode(data);
  return {
    "statusCode": response.statusCode,
    "data": responseData,
  };
}
