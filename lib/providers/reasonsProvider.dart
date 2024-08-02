import 'dart:convert';

import 'package:rally/config/hiveStorage.dart';
import 'package:rally/models/reasonsModel.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';

class ReasonsProvider {
  Future<ReasonsModel> fetch() async {
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: "$ACTIVATIONREASONS_URL",
        method: HTTPMETHOD.GET,
      ),
    );
    if (httpResult["ok"]) {
      saveHive(
        key: "reasons",
        data: json.encode(httpResult["data"]),
      );
      return ReasonsModel.fromJson(
        json: httpResult["data"],
        httpMsg: httpResult["data"]["msg"],
      );
    } else {
      return ReasonsModel.fromJson(
        httpMsg: httpResult["error"],
        json: httpResult["data"],
      );
    }
  }
}
