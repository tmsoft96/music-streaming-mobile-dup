import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/hiveStorage.dart';
import 'package:rally/config/repository/repo.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/properties.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/userModel.dart';
import 'firebase/firebaseAuth.dart';
import 'firebase/firebaseProfile.dart';

Future<void> loadHomepageFiles() async {
  Repository repo = new Repository();
  await repo.fetchAllNewMusic(true);
  await repo.fetchAllMusicAllSongs(true);
  await repo.fetchAllMusicTrending(true);
  await repo.fetchAllMusicTodaysHits(true);
  await repo.fetchAllAlbum(true);
  await repo.fetchAllMusicTopPicks(true);
  await repo.fetchAllMusic(true, null);
  await repo.fetchAllBanner(true);
}

Future<String> saveJsonFile({
  @required String? filename,
  @required dynamic data,
}) async {
  final file = File(
    '${(await getApplicationDocumentsDirectory()).path}/$filename.json',
  );
  await file.writeAsString(json.encode(data));

  String encodedData = await file.readAsString();
  return encodedData;
}

void callLauncher(String url) async {
  print("url $url");
  // ignore: deprecated_member_use
  if (await canLaunch(url)) {
    // ignore: deprecated_member_use
    await launch(url);
  } else {
    throw 'Could not open, try different text';
  }
}

String getReaderDate(
  String date, {
  bool showTimeOnly = false,
  bool showDateOnly = true,
}) {
  DateTime dateTime = DateTime.parse(date);
  String newDt = DateFormat.yMMMEd().format(dateTime);
  String newTime = DateFormat.jm().format(dateTime);
  return showTimeOnly && showDateOnly
      ? "$newDt $newTime"
      : showDateOnly
          ? "$newDt"
          : showTimeOnly
              ? "$newTime"
              : "Specify what to show";
}

String getNumberFormat(int number) {
  return NumberFormat.compact().format(number);
}

void inviteFrinds() {
  Share.share(
    "$TITLE, Discover your favorite radio and music. Get it at https://revoltafrica.net/",
  );
}

void shareContent({
  @required String? text,
  String? image,
}) {
  Share.share(
    text!,
    sharePositionOrigin: Rect.fromCenter(
      center: Offset(100, 100),
      width: 100,
      height: 100,
    ),
  );
}

Future<void> continueSignUpOnFirebase({
  @required String? firebaseUserId,
  @required UserModel? userModel,
}) async {
  FireAuth _firebaseAuth = new FireAuth();
  FireProfile _fireProfile = new FireProfile();
  if (firebaseUserId == null) {
    await _firebaseAuth.signIn(
      email: userModel!.data!.user!.email,
      password: DEFAULTPASSWORD,
      name: '${userModel.data!.user!.fname} ${userModel.data!.user!.lname}',
      userId: userModel.data!.user!.userid,
      role: userModel.data!.user!.role,
    );
  } else {
    await _fireProfile.createAccount(
      email: userModel!.data!.user!.email,
      name: '${userModel.data!.user!.fname} ${userModel.data!.user!.lname}',
      userId: userModel.data!.user!.userid,
      firebaseUserId: firebaseUserId,
      role: userModel.data!.user!.role,
    );
    _firebaseAuth.saveToken();
  }
}

String getTimeago(DateTime dateTime) {
  print("dataTIme $dateTime");
  return timeago.format(dateTime, locale: 'en_short', allowFromNow: true);
}

String convertFile(String path) {
  String s = path.substring(0, path.lastIndexOf("."));
  final image = decodeImage(File(path).readAsBytesSync())!;

  File('$s.jpg').writeAsBytesSync(encodeJpg(image));
  return '$s.jpg';
}

Future<void> contentDownload(Map<dynamic, dynamic> meta) async {
  if (allDownloadModel!.data != null)
    for (var downloadData in allDownloadModel!.data!) {
      if (meta["id"].toString() == downloadData.id) {
        toastContainer(
          text: "Content downloaded already",
          backgroundColor: GREEN,
        );
        return;
      }
    }

  String? encodedData = await getHive("downloadFiles");
  if (encodedData == null) {
    await saveHive(key: "downloadFiles", data: json.encode([meta]));
  } else {
    List<dynamic> decodedData = json.decode(encodedData);
    List<Map<dynamic, dynamic>> metaList =
        decodedData.cast<Map<dynamic, dynamic>>();
    List<Map<dynamic, dynamic>> newMetaList = metaList + [meta];
    await saveHive(key: "downloadFiles", data: json.encode(newMetaList));
    log("encodedData $encodedData");
  }
  Repository repo = new Repository();
  repo.fetchAllDownload();
  toastContainer(text: "Added to download list", backgroundColor: GREEN);
}
