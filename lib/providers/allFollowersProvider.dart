import 'dart:convert';

import 'package:rally/config/hiveStorage.dart';
import 'package:rally/models/allFollowersModel.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';

class AllFollowersProvider {
  Future<AllFollowersModel> fetch(
    String? userId, {
    bool isFetchFollowers = true,
  }) async {
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: isFetchFollowers
            ? "$FOLLOWERS_URL/$userId"
            : "$FOLLOWING_URL/$userId",
        method: HTTPMETHOD.GET,
      ),
    );
    if (httpResult["ok"]) {
      saveHive(
        key: isFetchFollowers ? "allFollower" : "allFollowing",
        data: json.encode(httpResult["data"]),
      );
      return AllFollowersModel.fromJson(
        json: httpResult["data"],
        httpMsg: httpResult["data"]["msg"],
      );
    } else {
      return AllFollowersModel.fromJson(
        httpMsg: httpResult["error"],
        json: httpResult["data"],
      );
    }
  }
}
