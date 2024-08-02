import 'dart:convert';

import 'package:rally/config/hiveStorage.dart';
import 'package:rally/models/allRegularUserModel.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';

class AllRegularUserProvider {
  Future<AllRegularUserModel> fetch() async {
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: "$ALLREGULARUSERS_URL",
        method: HTTPMETHOD.GET,
      ),
    );
    if (httpResult["ok"]) {
      saveHive(
        key: "allRegularUsers",
        data: json.encode(httpResult["data"]),
      );
      return AllRegularUserModel.fromJson(
        json: httpResult["data"],
        httpMsg: httpResult["data"]["msg"],
      );
    } else {
      return AllRegularUserModel.fromJson(
        httpMsg: httpResult["error"],
        json: httpResult["data"],
      );
    }
  }
}
