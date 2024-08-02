import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allMusicNewMusicModel.dart';
import 'package:rxdart/rxdart.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';

final _fetcher = BehaviorSubject<AllMusicNewMusicModel>();
Sink<AllMusicNewMusicModel> get _fetcherSink => _fetcher.sink;
Stream<AllMusicNewMusicModel> get allMusicNewMusicModelStream =>
    _fetcher.stream;
AllMusicNewMusicModel? allMusicNewMusicModel;

class AllMusicNewMusicProvider {
  String _filename = "allNewMusic";

  Future<AllMusicNewMusicModel> fetch() async {
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: FILTERNEWMUSIC_URL,
        method: HTTPMETHOD.GET,
      ),
    );
    if (httpResult["ok"]) {
      String encodedData = await saveJsonFile(
        filename: _filename,
        data: httpResult["data"],
      );
      allMusicNewMusicModel = AllMusicNewMusicModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: httpResult["data"]["msg"],
      );
      return allMusicNewMusicModel!;
    } else {
      allMusicNewMusicModel = AllMusicNewMusicModel.fromJson(
        httpMsg: httpResult["error"],
        json: httpResult["data"],
      );
      return allMusicNewMusicModel!;
    }
  }

  Future<void> get({bool isLoad = false}) async {
    final file = File(
      '${(await getApplicationDocumentsDirectory()).path}/$_filename.json',
    );
    bool exit = await file.exists();
    if (!isLoad && exit) {
      String encodedData = await file.readAsString();
      AllMusicNewMusicModel model = AllMusicNewMusicModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: "Offline data",
      );
      allMusicNewMusicModel = model;
      _fetcherSink.add(model);
    } else {
      AllMusicNewMusicModel model = await fetch();
      if (model.ok!) {
        allMusicNewMusicModel = model;
        _fetcherSink.add(model);
      } else {
        await get(isLoad: false);
      }
    }
  }
}
