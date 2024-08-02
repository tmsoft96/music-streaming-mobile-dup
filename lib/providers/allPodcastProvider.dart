import 'dart:convert';

import 'package:rally/config/hiveStorage.dart';
import 'package:rally/models/allPodcastModel.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';

class AllPodcastProvider {
  Future<AllPodcastModel> fetch() async {
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: ALLPODCASTS_URL,
        method: HTTPMETHOD.POST,
      ),
    );
    if (httpResult["ok"]) {
      saveHive(
        key: "allPodcast",
        data: json.encode(httpResult["data"]),
      );
      return AllPodcastModel.fromJson(
        json: httpResult["data"],
        httpMsg: httpResult["data"]["msg"],
      );
    } else {
      return AllPodcastModel.fromJson(
        httpMsg: httpResult["error"],
        json: httpResult["data"],
      );
    }
  }
}
