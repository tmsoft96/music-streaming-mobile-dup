import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:rally/config/repository/repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rally/config/sharePreference.dart';
import 'package:rally/models/userModel.dart';

import 'hiveStorage.dart';

UserModel? userModel;

Future<String> checkSession(void Function(String text) state) async {
  String auth = "not auth";
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("auth")) {
    if (prefs.getBool("auth")!) {
      auth = "auth";
    } else {
      auth = "not auth";
    }
  } else {
    saveBoolShare(key: "auth", data: false);
    auth = "not auth";
  }

  // auth = "not auth";
  await Future.delayed(Duration(seconds: 0), () async {
    //load all data here
    String? encodedData = await getHive("userDetails");

    if (encodedData != null) {
      var decodedData = json.decode(encodedData);
      print(decodedData);
      userModel = UserModel.fromJson(decodedData);
    } else {
      print("please log in");
      auth = "not auth";
    }

    // load other files
    await getAllOtherFiles(state: state);
  });

  return auth;
}

Future<void> getAllOtherFiles({
  @required void Function(String text)? state,
}) async {
  Repository repo = new Repository();
  state!("0");
  await repo.fetchRecentlyPlayedSingle();
  state("5");
  await repo.fetchAllNewMusic(false);
  state("10");
  await repo.fetchAllMusicAllSongs(false);
  state("20");
  await repo.fetchAllMusicTrending(false);
  state("30");
  await repo.fetchRecentlyPlayedJoint();
  state("35");
  await repo.fetchAllArtists(false, 0);
  state("40");
  await repo.fetchAllMusicTodaysHits(false);
  state("50");
  await repo.fetchAllAlbum(false);
  state("60");
  await repo.fetchAllMusicTopPicks(false);
  state("70");
  await repo.fetchAllMusic(false, null);
  state("80");
  await repo.fetchAllBanner(false);
  state("90");
  await repo.fetchAllPlaylists(false, "", "0");
  state("95");
  repo.fetchAllDownload();
  state("100");
}
