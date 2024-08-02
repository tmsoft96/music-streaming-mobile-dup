import 'dart:convert';

import 'package:rally/config/hiveStorage.dart';
import 'package:rally/models/myPlaylistsModel.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';

class MyPlaylistsProvider {
  Future<MyPlaylistsModel> fetch(String? userId, String? status) async {
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
          endPoint: "$FETCHPLAYLISTS_URL",
          method: HTTPMETHOD.POST,
          httpPostBody: {
            "userid": userId ?? "",
            "status": status ?? "",
          }),
    );
    if (httpResult["ok"]) {
      saveHive(
        key: "myPlaylists$userId$status",
        data: json.encode(httpResult["data"]),
      );
      return MyPlaylistsModel.fromJson(
        json: httpResult["data"],
        httpMsg: httpResult["data"]["msg"],
      );
    } else {
      return MyPlaylistsModel.fromJson(
        httpMsg: httpResult["error"],
        json: httpResult["data"],
      );
    }
  }
}
