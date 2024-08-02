import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rxdart/rxdart.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';

final _fetcher = BehaviorSubject<AllMusicModel>();
Sink<AllMusicModel> get _fetcherSink => _fetcher.sink;
Stream<AllMusicModel> get allMusicModelStream => _fetcher.stream;
AllMusicModel? allMusicModel;

class AllMusicProvider {
  String _filename = "allMusic";

  Future<AllMusicModel> fetch(String? filterArtistId) async {
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: MUSIC_URL,
        method: HTTPMETHOD.GET,
      ),
    );
    if (httpResult["ok"]) {
      String encodedData = await saveJsonFile(
        filename: _filename,
        data: httpResult["data"],
      );
      allMusicModel = AllMusicModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: httpResult["data"]["msg"],
        filterByArtistId: filterArtistId,
      );
      return allMusicModel!;
    } else {
      allMusicModel = AllMusicModel.fromJson(
        httpMsg: httpResult["error"],
        json: httpResult["data"],
        filterByArtistId: filterArtistId,
      );
      return allMusicModel!;
    }
  }

  Future<void> get({bool isLoad = false, String? filterArtistId}) async {
    final file = File(
      '${(await getApplicationDocumentsDirectory()).path}/$_filename.json',
    );
    bool exit = await file.exists();
    if (!isLoad && exit) {
      String encodedData = await file.readAsString();
      AllMusicModel model = AllMusicModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: "Offline data",
        filterByArtistId: filterArtistId,
      );
      allMusicModel = model;
      _fetcherSink.add(model);
    } else {
      AllMusicModel model = await fetch(filterArtistId);
      if (model.ok!) {
        allMusicModel = model;
        _fetcherSink.add(model);
      } else {
        await get(isLoad: false, filterArtistId: null);
      }
    }
  }
}
