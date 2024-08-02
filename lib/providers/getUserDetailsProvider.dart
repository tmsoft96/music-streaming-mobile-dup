import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:rally/models/userModel.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';
import '../config/sharePreference.dart';

class GetUserDetailsProvider {
  Future<UserModel> fetch({
    @required String? userId,
    @required String? token,
  }) async {
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: "$GETUSERDETAILS_URL/$userId",
        method: HTTPMETHOD.GET,
      ),
    );
    if (httpResult["ok"]) {
      Map<String, dynamic> userData = {
        "ok": httpResult["data"]["ok"],
        "msg": httpResult["data"]["msg"],
        "data": {
          "token": token,
          "user": httpResult["data"]["data"],
        },
      };
      saveStringShare(
        key: "userDetails",
        data: json.encode(userData),
      );
      return UserModel.fromJson(userData);
    } else {
      return UserModel.fromJson(httpResult["data"]);
    }
  }
}
