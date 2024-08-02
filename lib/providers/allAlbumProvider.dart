import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allAlbumModel.dart';
import 'package:rxdart/rxdart.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';

final _fetcher = BehaviorSubject<AllAlbumModel>();
Sink<AllAlbumModel> get _fetcherSink => _fetcher.sink;
Stream<AllAlbumModel> get allAlbumModelStream => _fetcher.stream;
AllAlbumModel? allAlbumModel;

class AllAlbumProvider {
  Future<AllAlbumModel> fetch(String? status, String? filterArtistId) async {
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: "$ALLALBUMS_URL",
        method: HTTPMETHOD.POST,
        httpPostBody: {"status": status},
        // showLog: true,
      ),
    );
    if (httpResult["ok"]) {
      String encodedData = await saveJsonFile(
        filename: "allAlbum$status$filterArtistId",
        data: httpResult["data"],
      );
      allAlbumModel = AllAlbumModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: httpResult["data"]["msg"],
        filterByArtistId: filterArtistId,
      );
      return allAlbumModel!;
    } else {
      allAlbumModel = AllAlbumModel.fromJson(
        httpMsg: httpResult["error"],
        json: httpResult["data"],
        filterByArtistId: filterArtistId,
      );
      return allAlbumModel!;
    }
  }

  Future<void> get({
    bool isLoad = false,
    String? status,
    String? filterArtistId,
  }) async {
    String filename = "allAlbum$status$filterArtistId";
    final file = File(
      '${(await getApplicationDocumentsDirectory()).path}/$filename.json',
    );
    bool exit = await file.exists();
    if (!isLoad && exit) {
      String encodedData = await file.readAsString();
      AllAlbumModel model = AllAlbumModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: "Offline data",
        filterByArtistId: filterArtistId,
      );
      allAlbumModel = model;
      _fetcherSink.add(model);
    } else {
      AllAlbumModel model = await fetch(status, filterArtistId);
      if (model.ok!) {
        allAlbumModel = model;
        _fetcherSink.add(model);
      } else {
        await get(isLoad: false);
      }
    }
  }
}
