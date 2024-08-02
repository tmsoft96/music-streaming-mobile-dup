import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:rally/config/hiveStorage.dart';
import 'package:rally/models/checkFollowingModel.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';

class CheckFollowingProvider {
  Future<CheckFollowingModel> fetch({
    @required String? userId,
    @required String? followId,
  }) async {
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: "$CHECKFOLLOWING_URL/$userId/$followId",
        method: HTTPMETHOD.GET,
      ),
    );
    if (httpResult["ok"]) {
      saveHive(
        key: "checkFollowing$userId$followId",
        data: json.encode(httpResult["data"]),
      );
      return CheckFollowingModel.fromJson(
        json: httpResult["data"],
        httpMsg: httpResult["data"]["msg"],
      );
    } else {
      return CheckFollowingModel.fromJson(
        httpMsg: httpResult["error"],
        json: httpResult["data"],
      );
    }
  }
}
