import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allMusicAllSongsModel.dart';
import 'package:rxdart/rxdart.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';

final _fetcher = BehaviorSubject<AllMusicAllSongsModel>();
Sink<AllMusicAllSongsModel> get _fetcherSink => _fetcher.sink;
Stream<AllMusicAllSongsModel> get allMusicAllSongsModelStream =>
    _fetcher.stream;
AllMusicAllSongsModel? allMusicAllSongsModel;

class AllMusicAllSongsProvider {
  String _filename = "allSongs";

  Future<AllMusicAllSongsModel> fetch() async {
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: FILTERALLSONGS_URL,
        method: HTTPMETHOD.GET,
      ),
    );
    if (httpResult["ok"]) {
      String encodedData = await saveJsonFile(
        filename: _filename,
        data: httpResult["data"],
      );
      allMusicAllSongsModel = AllMusicAllSongsModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: httpResult["data"]["msg"],
      );
      return allMusicAllSongsModel!;
    } else {
      allMusicAllSongsModel = AllMusicAllSongsModel.fromJson(
        httpMsg: httpResult["error"],
        json: httpResult["data"],
      );
      return allMusicAllSongsModel!;
    }
  }

  Future<void> get({bool isLoad = false}) async {
    final file = File(
      '${(await getApplicationDocumentsDirectory()).path}/$_filename.json',
    );
    bool exit = await file.exists();
    if (!isLoad && exit) {
      String encodedData = await file.readAsString();
      AllMusicAllSongsModel model = AllMusicAllSongsModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: "Offline data",
      );
      allMusicAllSongsModel = model;
      _fetcherSink.add(model);
    } else {
      AllMusicAllSongsModel model = await fetch();
      if (model.ok!) {
        allMusicAllSongsModel = model;
        _fetcherSink.add(model);
      } else {
        await get(isLoad: false);
      }
    }
  }
}
