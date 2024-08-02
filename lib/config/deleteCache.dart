import 'package:flutter/material.dart';

import 'hiveStorage.dart';


Future<void> deleteCache() async {
  imageCache.clear();

  List<String> cacheList = [
    "userDetails",
    "allGenre",
    "allFollower",
    "allFollowing",
    "allRegularUsers",
    "allPodcast",
  ];

  for (String key in cacheList) await deleteHive(key);
}
