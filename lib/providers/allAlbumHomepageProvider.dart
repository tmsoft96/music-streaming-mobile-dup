import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allAlbumHomepageModel.dart';
import 'package:rxdart/rxdart.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';

final _fetcher = BehaviorSubject<AllAlbumHomepageModel>();
Sink<AllAlbumHomepageModel> get _fetcherSink => _fetcher.sink;
Stream<AllAlbumHomepageModel> get allAlbumHomepageModelStream =>
    _fetcher.stream;
AllAlbumHomepageModel? allAlbumHomepageModel;

class AllAlbumHomepageProvider {
  String _filename = "allAlbum";

  Future<AllAlbumHomepageModel> fetch() async {
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: "$ALLALBUMS_URL",
        method: HTTPMETHOD.POST,
        httpPostBody: {"status": "0"},
        // showLog: true,
      ),
    );
    if (httpResult["ok"]) {
      String encodedData = await saveJsonFile(
        filename: _filename,
        data: httpResult["data"],
      );
      allAlbumHomepageModel = AllAlbumHomepageModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: httpResult["data"]["msg"],
        filterByArtistId: null,
      );
      return allAlbumHomepageModel!;
    } else {
      allAlbumHomepageModel = AllAlbumHomepageModel.fromJson(
        httpMsg: httpResult["error"],
        json: httpResult["data"],
        filterByArtistId: null,
      );
      return allAlbumHomepageModel!;
    }
  }

  Future<void> get({bool isLoad = false}) async {
    final file = File(
      '${(await getApplicationDocumentsDirectory()).path}/$_filename.json',
    );
    bool exit = await file.exists();
    if (!isLoad && exit) {
      String encodedData = await file.readAsString();
      AllAlbumHomepageModel model = AllAlbumHomepageModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: "Offline data",
        filterByArtistId: null,
      );
      allAlbumHomepageModel = model;
      _fetcherSink.add(model);
    } else {
      AllAlbumHomepageModel model = await fetch();
      if (model.ok!) {
        allAlbumHomepageModel = model;
        _fetcherSink.add(model);
      } else {
        await get(isLoad: false);
      }
    }
  }
}
