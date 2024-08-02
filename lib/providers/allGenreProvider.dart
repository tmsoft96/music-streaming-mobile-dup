import 'dart:convert';

import 'package:rally/config/hiveStorage.dart';
import 'package:rally/models/allGenreModel.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';

class AllGenreProvider {
  Future<AllGenreModel> fetch() async {
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: GENRE_URL,
        method: HTTPMETHOD.GET,
      ),
    );
    if (httpResult["ok"]) {
      saveHive(
        key: "allGenre",
        data: json.encode(httpResult["data"]),
      );
      return AllGenreModel.fromJson(
        json: httpResult["data"],
        httpMsg: httpResult["data"]["msg"],
      );
    } else {
      return AllGenreModel.fromJson(
        httpMsg: httpResult["error"],
        json: httpResult["data"],
      );
    }
  }
}
