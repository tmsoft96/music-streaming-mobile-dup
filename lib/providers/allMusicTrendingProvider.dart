import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allMusicTrendingModel.dart';
import 'package:rxdart/rxdart.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';

final _fetcher = BehaviorSubject<AllMusicTrendingModel>();
Sink<AllMusicTrendingModel> get _fetcherSink => _fetcher.sink;
Stream<AllMusicTrendingModel> get allMusicTrendingModelStream =>
    _fetcher.stream;
AllMusicTrendingModel? allMusicTrendingModel;

class AllMusicTrendingProvider {
  String _filename = "allTrending";

  Future<AllMusicTrendingModel> fetch() async {
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: FILTERTRENDING_URL,
        method: HTTPMETHOD.GET,
      ),
    );
    if (httpResult["ok"]) {
      String encodedData = await saveJsonFile(
        filename: _filename,
        data: httpResult["data"],
      );
      allMusicTrendingModel = AllMusicTrendingModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: httpResult["data"]["msg"],
      );
      return allMusicTrendingModel!;
    } else {
      allMusicTrendingModel = AllMusicTrendingModel.fromJson(
        httpMsg: httpResult["error"],
        json: httpResult["data"],
      );
      return allMusicTrendingModel!;
    }
  }

  Future<void> get({bool isLoad = false}) async {
    final file = File(
      '${(await getApplicationDocumentsDirectory()).path}/$_filename.json',
    );
    bool exit = await file.exists();
    if (!isLoad && exit) {
      String encodedData = await file.readAsString();
      AllMusicTrendingModel model = AllMusicTrendingModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: "Offline data",
      );
      allMusicTrendingModel = model;
      _fetcherSink.add(model);
    } else {
      AllMusicTrendingModel model = await fetch();
      if (model.ok!) {
        allMusicTrendingModel = model;
        _fetcherSink.add(model);
      } else {
        await get(isLoad: false);
      }
    }
  }
}
