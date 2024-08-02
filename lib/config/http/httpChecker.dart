import 'dart:async';

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rally/spec/strings.dart';

import '../../components/toast.dart';
import '../../spec/colors.dart';

Future<Map<String, dynamic>> httpChecker({
  @required Future<Map<String, dynamic>> Function()? httpRequesting,
  bool showToastMsg = false,
}) async {
  try {
    Map<String, dynamic> httpMap = await httpRequesting!();
    if (httpMap["statusCode"] >= 100 && httpMap["statusCode"] <= 199) {
      if (showToastMsg)
        toastContainer(
          text: "${httpMap["statusCode"]}-${httpMap["data"]["msg"]}",
          backgroundColor: RED,
        );
      return {
        "ok": httpMap["data"]["ok"],
        "statusCode": httpMap["statusCode"],
        "data": null,
        "statusMsg": "Information responses",
      };
    } else if (httpMap["statusCode"] >= 200 && httpMap["statusCode"] <= 299) {
      return {
        "ok": httpMap["data"]["ok"],
        "statusCode": httpMap["statusCode"],
        "data": httpMap["data"],
        "statusMsg": "Successful responses",
      };
    } else if (httpMap["statusCode"] >= 300 && httpMap["statusCode"] <= 399) {
      if (showToastMsg)
        toastContainer(
          text: "${httpMap["statusCode"]}-${httpMap["data"]["msg"]}",
          backgroundColor: RED,
        );
      return {
        "ok": httpMap["data"]["ok"],
        "statusCode": httpMap["statusCode"],
        "data": null,
        "statusMsg": "Redirects",
      };
    } else if (httpMap["statusCode"] >= 400 && httpMap["statusCode"] <= 499) {
      if (showToastMsg)
        toastContainer(
          text: "${httpMap["statusCode"]}-${httpMap["data"]["msg"]}",
          backgroundColor: RED,
        );
      return {
        "ok": httpMap["data"]["ok"],
        "statusCode": httpMap["statusCode"],
        "data": httpMap["data"],
        "statusMsg": "Client errors",
        "error": httpMap["data"]["msg"],
      };
    } else {
      if (showToastMsg)
        toastContainer(text: REQUESTERROR, backgroundColor: RED);
      return {
        "ok": httpMap["data"]["ok"],
        "statusCode": httpMap["statusCode"],
        "data": null,
        "statusMsg": "Errors",
        "error": "Internal Error",
      };
    }
  } on TimeoutException catch (error) {
    print(error);
    toastContainer(text: CONNECTIONTIMEOUT, backgroundColor: RED);
    return {
      "ok": false,
      "statusCode": null,
      "data": null,
      "statusMsg": "Errors",
      "error": CONNECTIONTIMEOUT,
    };
  } on SocketException catch (error) {
    print(error);
    toastContainer(text: NOINTERNET, backgroundColor: RED);
    return {
      "ok": false,
      "statusCode": null,
      "data": null,
      "statusMsg": "Errors",
      "error": NOINTERNET,
    };
  } catch (e) {
    if (showToastMsg) toastContainer(text: REQUESTERROR, backgroundColor: RED);
    return {
      "ok": false,
      "statusCode": null,
      "data": null,
      "statusMsg": "Errors",
      "error": REQUESTERROR,
    };
  }
}
