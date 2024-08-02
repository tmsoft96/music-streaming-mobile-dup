import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkConnection.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/firebase/firebaseService.dart';
import 'package:rally/config/hiveStorage.dart';
import 'package:rally/models/favoriteContentModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/strings.dart';
import 'package:rxdart/rxdart.dart';

final _fetcher = BehaviorSubject<FavoriteContentModel>();
Sink<FavoriteContentModel> get _fetcherSink => _fetcher.sink;
Stream<FavoriteContentModel> get favoriteContentModelStream => _fetcher.stream;
FavoriteContentModel? favoriteContentModel;

class FavoriteContentProvider {
  FirebaseService _firebaseService = new FirebaseService();

  Future<void> fetch() async {
    // offline favorite list
    String? encodedData = await getHive("favorite");
    if (encodedData != null) {
      favoriteContentModel =
          FavoriteContentModel.fromJson(json.decode(encodedData));
      _fetcherSink.add(favoriteContentModel!);
    }

    checkConnection().then((connection) async {
      if (connection) {
        String userId = userModel!.data!.user!.userid!;
        final reference =
            FirebaseFirestore.instance.collection("Favorite").doc(userId);
        reference.snapshots().listen((DocumentSnapshot snapshot) {
          try {
            Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
            List<dynamic> contentIdList = data["contentIds"];
            print("favorite $data");
            favoriteContentModel = FavoriteContentModel.fromJson(contentIdList);
            _fetcherSink.add(favoriteContentModel!);
            saveHive(key: "favorite", data: json.encode(contentIdList));
          } catch (e) {
            log(e.toString());
          }
        });
      }
    });
  }

  bool check(String contentId) {
    if (favoriteContentModel != null &&
        favoriteContentModel!.contentIdList!.length > 0) {
      bool isExit =
          favoriteContentModel!.contentIdList!.indexOf(contentId) != -1;
      // log("isFavorite $isExit");
      return isExit;
    } else {
      // log("isFavorite false");
      return false;
    }
  }

  void saveDelete(String contentId, void Function()? state) {
    checkConnection().then((connection) async {
      if (connection) {
        if (favoriteContentModel != null &&
            favoriteContentModel!.contentIdList!.length > 0) {
          bool isExit = check(contentId);
          if (isExit) {
            int index = favoriteContentModel!.contentIdList!.indexOf(contentId);
            favoriteContentModel!.contentIdList!.removeAt(index);
          } else {
            favoriteContentModel!.addContent(contentId);
          }
          await _firebaseService.savefavorite(
            contentIdList: favoriteContentModel!.toJson(),
          );
          state!();
        } else {
          await _firebaseService.savefavorite(contentIdList: [contentId]);
          state!();
        }
      } else {
        state!();
        toastContainer(text: NOINTERNET, backgroundColor: RED);
      }
    });
  }
}

bool checkContentFavorite({
  @required String? type,
  @required String? contentId,
}) =>
    FavoriteContentProvider().check("$type$contentId");

void saveDeleteContentFavorite({
  // type: single, playlist, album, podcast, video
  @required String? type,
  @required String? contentId,
  @required void Function()? state,
}) =>
    FavoriteContentProvider().saveDelete("$type$contentId", state);
