import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/bannersModel.dart';
import 'package:rxdart/rxdart.dart';

import '../config/http/httpChecker.dart';
import '../config/http/httpRequester.dart';
import '../config/services.dart';

final _fetcher = BehaviorSubject<AllBannersModel>();
Sink<AllBannersModel> get _fetcherSink => _fetcher.sink;
Stream<AllBannersModel> get allBannersModelStream => _fetcher.stream;
AllBannersModel? allBannersModel;

class AllBannersProvider {
  String _filename = "allBanners";

  Future<AllBannersModel> fetch() async {
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: "$ALLBANNERS_URL",
        method: HTTPMETHOD.GET,
      ),
    );
    if (httpResult["ok"]) {
      String encodedData = await saveJsonFile(
        filename: _filename,
        data: httpResult["data"],
      );
      allBannersModel = AllBannersModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: httpResult["data"]["msg"],
      );
      return allBannersModel!;
    } else {
      allBannersModel = AllBannersModel.fromJson(
        httpMsg: httpResult["error"],
        json: httpResult["data"],
      );
      return allBannersModel!;
    }
  }

  Future<void> get({bool isLoad = false}) async {
    final file = File(
      '${(await getApplicationDocumentsDirectory()).path}/$_filename.json',
    );
    bool exit = await file.exists();
    if (!isLoad && exit) {
      String encodedData = await file.readAsString();
      AllBannersModel model = AllBannersModel.fromJson(
        json: json.decode(encodedData),
        httpMsg: "Offline data",
      );
      allBannersModel = model;
      _fetcherSink.add(model);
    } else {
      AllBannersModel model = await fetch();
      if (model.ok!) {
        allBannersModel = model;
        _fetcherSink.add(model);
      } else {
        await get(isLoad: false);
      }
    }
  }
}
