import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allPlaylistsModel.dart';
import 'package:rxdart/rxdart.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';

final _fetcher = BehaviorSubject<AllPlaylistsModel>();
Sink<AllPlaylistsModel> get _fetcherSink => _fetcher.sink;
Stream<AllPlaylistsModel> get allPlaylistsModelStream => _fetcher.stream;
AllPlaylistsModel? allPlaylistsModel;

class AllPlaylistsProvider {
  Future<AllPlaylistsModel> fetch(String? userId, String? status) async {
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
      String encodedData = await saveJsonFile(
        filename: "allPlaylists$userId$status",
        data: httpResult["data"],
      );
      allPlaylistsModel = AllPlaylistsModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: httpResult["data"]["msg"],
      );
      return allPlaylistsModel!;
    } else {
      allPlaylistsModel = AllPlaylistsModel.fromJson(
        httpMsg: httpResult["error"],
        json: httpResult["data"],
      );
      return allPlaylistsModel!;
    }
  }

  Future<void> get({
    bool isLoad = false,
    String? userId,
    String? status,
  }) async {
    final file = File(
      '${(await getApplicationDocumentsDirectory()).path}/allPlaylists$userId$status.json',
    );
    bool exit = await file.exists();
    if (!isLoad && exit) {
      String encodedData = await file.readAsString();
      AllPlaylistsModel model = AllPlaylistsModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: "Offline data",
      );
      allPlaylistsModel = model;
      _fetcherSink.add(model);
    } else {
      AllPlaylistsModel model = await fetch(userId, status);
      if (model.ok!) {
        allPlaylistsModel = model;
        _fetcherSink.add(model);
      } else {
        await get(isLoad: false, userId: "", status: "0");
      }
    }
  }
}
