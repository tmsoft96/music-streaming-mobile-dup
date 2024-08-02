import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allMusicTodaysHitsModel.dart';
import 'package:rxdart/rxdart.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';

final _fetcher = BehaviorSubject<AllMusicTodaysHitsModel>();
Sink<AllMusicTodaysHitsModel> get _fetcherSink => _fetcher.sink;
Stream<AllMusicTodaysHitsModel> get allMusicTodaysHitsModelStream =>
    _fetcher.stream;
AllMusicTodaysHitsModel? allMusicTodaysHitsModel;

class AllMusicTodaysHitsProvider {
  String _filename = "allTodaysHits";

  Future<AllMusicTodaysHitsModel> fetch() async {
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: FILTERTODAYSHITS_URL,
        method: HTTPMETHOD.GET,
      ),
    );
    if (httpResult["ok"]) {
      String encodedData = await saveJsonFile(
        filename: _filename,
        data: httpResult["data"],
      );
      allMusicTodaysHitsModel = AllMusicTodaysHitsModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: httpResult["data"]["msg"],
      );
      return allMusicTodaysHitsModel!;
    } else {
      allMusicTodaysHitsModel = AllMusicTodaysHitsModel.fromJson(
        httpMsg: httpResult["error"],
        json: httpResult["data"],
      );
      return allMusicTodaysHitsModel!;
    }
  }

  Future<void> get({bool isLoad = false}) async {
    final file = File(
      '${(await getApplicationDocumentsDirectory()).path}/$_filename.json',
    );
    bool exit = await file.exists();
    if (!isLoad && exit) {
      String encodedData = await file.readAsString();

      AllMusicTodaysHitsModel model = AllMusicTodaysHitsModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: "Offline data",
      );
      allMusicTodaysHitsModel = model;
      _fetcherSink.add(model);
    } else {
      AllMusicTodaysHitsModel model = await fetch();
      if (model.ok!) {
        allMusicTodaysHitsModel = model;
        _fetcherSink.add(model);
      } else {
        await get(isLoad: false);
      }
    }
  }
}
