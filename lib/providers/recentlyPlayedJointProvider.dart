import 'dart:convert';

import 'package:rally/config/hiveStorage.dart';
import 'package:rally/models/recentlyPlayedJointModel.dart';
import 'package:rxdart/rxdart.dart';

final _fetcher = BehaviorSubject<RecentlyPlayedJointModel>();
Sink<RecentlyPlayedJointModel> get _fetcherSink => _fetcher.sink;
Stream<RecentlyPlayedJointModel> get recentlyPlayedJointStream =>
    _fetcher.stream;
RecentlyPlayedJointModel? recentlyPlayedJointModel;

class RecentlyPlayedJointProvider {
  Future<void> get() async {
    String? encodedData = await getHive("recentPlayJoint");
    if (encodedData != null) {
      List<dynamic> decodedData = json.decode(encodedData);
      List<Map<dynamic, dynamic>> metaList =
          decodedData.cast<Map<dynamic, dynamic>>();
      RecentlyPlayedJointModel model = RecentlyPlayedJointModel.fromJson(
        {"data": metaList},
      );
      recentlyPlayedJointModel = model;
      _fetcherSink.add(model);
    } else {
      RecentlyPlayedJointModel model = RecentlyPlayedJointModel.fromJson(
        {"data": null},
      );
      recentlyPlayedJointModel = model;
      _fetcherSink.add(model);
    }
  }
}
