import 'dart:convert';

import 'package:rally/config/hiveStorage.dart';
import 'package:rally/models/recentlyPlayedSingleModel.dart';
import 'package:rxdart/rxdart.dart';

final _fetcher = BehaviorSubject<RecentlyPlayedSingleModel>();
Sink<RecentlyPlayedSingleModel> get _fetcherSink => _fetcher.sink;
Stream<RecentlyPlayedSingleModel> get recentlyPlayedSingleStream =>
    _fetcher.stream;
RecentlyPlayedSingleModel? recentlyPlayedSingleModel;

class RecentlyPlayedSingleProvider {
  Future<void> get() async {
    String? encodedData = await getHive("recentPlaySingles");
    if (encodedData != null) {
      List<dynamic> decodedData = json.decode(encodedData);
      List<Map<dynamic, dynamic>> metaList =
          decodedData.cast<Map<dynamic, dynamic>>();
      RecentlyPlayedSingleModel model = RecentlyPlayedSingleModel.fromJson(
        {"data": metaList},
      );
      recentlyPlayedSingleModel = model;
      _fetcherSink.add(model);
    } else {
      RecentlyPlayedSingleModel model = RecentlyPlayedSingleModel.fromJson(
        {"data": null},
      );
      recentlyPlayedSingleModel = model;
      _fetcherSink.add(model);
    }
  }
}
