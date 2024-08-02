import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:rally/config/hiveStorage.dart';

Map<String, dynamic>? allGenreMapOffline;
Future<void> loadAllGenreMapOffline() async {
  String? encodeData = await getHive("allGenre");
  if (encodeData != null) {
    allGenreMapOffline = json.decode(encodeData);
  } else
    allGenreMapOffline = null;
}

Map<String, dynamic>? checkFollowingMapOffline;
Future<void> loadAllCheckFollowingMapOffline({
  @required String? userId,
  @required String? followId,
}) async {
  String? encodeData = await getHive("checkFollowing$userId$followId");
  if (encodeData != null) {
    checkFollowingMapOffline = json.decode(encodeData);
  } else
    checkFollowingMapOffline = null;
}

Map<String, dynamic>? allFollowersMapOffline;
Future<void> loadAllFollowerMapOffline({
  bool isFetchFollowers = true,
}) async {
  String? encodeData = await getHive(
    isFetchFollowers ? "allFollower" : "allFollowing",
  );
  if (encodeData != null) {
    allFollowersMapOffline = json.decode(encodeData);
  } else
    allFollowersMapOffline = null;
}

Map<String, dynamic>? allRegularUserMapOffline;
Future<void> loadAllRegularUserMapOffline() async {
  String? encodeData = await getHive("allRegularUsers");
  if (encodeData != null) {
    allRegularUserMapOffline = json.decode(encodeData);
  } else
    allRegularUserMapOffline = null;
}

Map<String, dynamic>? allPodcastMapOffline;
Future<void> loadAllPodcastMapOffline() async {
  String? encodeData = await getHive("allPodcast");
  if (encodeData != null) {
    allPodcastMapOffline = json.decode(encodeData);
  } else
    allPodcastMapOffline = null;
}

Map<String, dynamic>? myPlaylistsMapOffline;
Future<void> loadMyPlaylistsMapOffline(String? userId, String? status) async {
  String? encodeData = await getHive("myPlaylists$userId$status");
  if (encodeData != null) {
    myPlaylistsMapOffline = json.decode(encodeData);
  } else
    myPlaylistsMapOffline = null;
}

Map<String, dynamic>? reasonsMapOffline;
Future<void> loadReasonsMapOffline() async {
  String? encodeData = await getHive("reasons");
  if (encodeData != null) {
    reasonsMapOffline = json.decode(encodeData);
  } else
    reasonsMapOffline = null;
}
