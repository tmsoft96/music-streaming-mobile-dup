import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allMusicTopPicksModel.dart';
import 'package:rxdart/rxdart.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';

final _fetcher = BehaviorSubject<AllMusicTopPicksModel>();
Sink<AllMusicTopPicksModel> get _fetcherSink => _fetcher.sink;
Stream<AllMusicTopPicksModel> get allMusicTopPicksModelStream =>
    _fetcher.stream;
AllMusicTopPicksModel? allMusicTopPicksModel;

class AllMusicTopPicksProvider {
  String _filename = "allTopPicks";

  Future<AllMusicTopPicksModel> fetch() async {
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: FILTERTOPPICKS_URL,
        method: HTTPMETHOD.GET,
      ),
    );
    if (httpResult["ok"]) {
      String encodedData = await saveJsonFile(
        filename: _filename,
        data: httpResult["data"],
      );
      allMusicTopPicksModel = AllMusicTopPicksModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: httpResult["data"]["msg"],
      );
      return allMusicTopPicksModel!;
    } else {
      allMusicTopPicksModel = AllMusicTopPicksModel.fromJson(
        httpMsg: httpResult["error"],
        json: httpResult["data"],
      );
      return allMusicTopPicksModel!;
    }
  }

  Future<void> get({bool isLoad = false}) async {
    final file = File(
      '${(await getApplicationDocumentsDirectory()).path}/$_filename.json',
    );
    bool exit = await file.exists();
    if (!isLoad && exit) {
      String encodedData = await file.readAsString();
      AllMusicTopPicksModel model = AllMusicTopPicksModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: "Offline data",
      );
      allMusicTopPicksModel = model;
      _fetcherSink.add(model);
    } else {
      AllMusicTopPicksModel model = await fetch();
      if (model.ok!) {
        allMusicTopPicksModel = model;
        _fetcherSink.add(model);
      } else {
        await get(isLoad: false);
      }
    }
  }
}
