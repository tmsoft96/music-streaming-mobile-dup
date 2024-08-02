import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allArtistsModel.dart';
import 'package:rxdart/rxdart.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';

final _fetcher = BehaviorSubject<AllArtistsModel>();
Sink<AllArtistsModel> get _fetcherSink => _fetcher.sink;
Stream<AllArtistsModel> get allArtistsModelStream => _fetcher.stream;
AllArtistsModel? allArtistsModel;

class AllArtistsProvider {
  // 2 - declined artist
  // 1 - pending artist
  // 0 or any other - approved artist
  Future<AllArtistsModel> fetch(int fetchArtistType) async {
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: fetchArtistType == 2
            ? DECLINEDARTISTS_URL
            : fetchArtistType == 1
                ? PENDINGARTISTS_URL
                : ALLARTISTS_URL,
        method: HTTPMETHOD.GET,
      ),
    );
    if (httpResult["ok"]) {
      String encodedData = await saveJsonFile(
        filename: fetchArtistType == 2
            ? "declinedArtists"
            : fetchArtistType == 1
                ? "pendingArtists"
                : "allArtists",
        data: httpResult["data"],
      );

      allArtistsModel = AllArtistsModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: httpResult["data"]["msg"],
      );
      return allArtistsModel!;
    } else {
      allArtistsModel = AllArtistsModel.fromJson(
        httpMsg: httpResult["error"],
        json: httpResult["data"],
      );
      return allArtistsModel!;
    }
  }

  Future<void> get({bool isLoad = false, int? fetchArtistType}) async {
    String filename = fetchArtistType == 2
        ? "declinedArtists"
        : fetchArtistType == 1
            ? "pendingArtists"
            : "allArtists";
    final file = File(
      '${(await getApplicationDocumentsDirectory()).path}/$filename.json',
    );
    bool exit = await file.exists();
    if (!isLoad && exit) {
      String encodedData = await file.readAsString();
      AllArtistsModel model = AllArtistsModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: "Offline data",
      );
      allArtistsModel = model;
      _fetcherSink.add(model);
    } else {
      AllArtistsModel model = await fetch(fetchArtistType!);
      if (model.ok!) {
        allArtistsModel = model;
        _fetcherSink.add(model);
      } else {
        await get(isLoad: false, fetchArtistType: 0);
      }
    }
  }
}
