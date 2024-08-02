import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:rally/config/checkSession.dart';

abstract class _BaseDatabase {
  Future<void> saveComment();

  Future<void> reactionComment();

  Future<void> savefavorite();
}

class FirebaseService implements _BaseDatabase {
  @override
  Future<void> saveComment({
    @required String? contentId,
    @required String? comment,
  }) async {
    String userId = userModel!.data!.user!.userid!;
    final CollectionReference _collection =
        FirebaseFirestore.instance.collection("Comments");
    String commentId = DateTime.now().millisecondsSinceEpoch.toString();
    await _collection.doc(contentId).collection("users").doc(commentId).set({
      "contentId": contentId,
      "userId": userId,
      "comment": comment,
      "commentId": commentId,
      "profilePicture": userModel!.data!.user!.picture,
      "name": userModel!.data!.user!.stageName ?? userModel!.data!.user!.fname,
      "delete": 0,
      "createdDate": Timestamp.now(),
    });
  }

  @override
  Future<void> reactionComment({
    @required String? contentId,
    @required String? commentId,
    @required List<String>? allLikeReactorsId,
    @required List<String>? allUnlikeReactorsId,
  }) async {
    final CollectionReference _collection =
        FirebaseFirestore.instance.collection("Comments");
    await _collection.doc(contentId).collection("users").doc(commentId).update({
      "likeReaction": allLikeReactorsId,
      "unlikeReaction": allUnlikeReactorsId,
    });
  }
  
  @override
  Future<void> savefavorite({
    @required List<String>? contentIdList,
  }) async {
    String userId = userModel!.data!.user!.userid!;
    final CollectionReference _collection =
        FirebaseFirestore.instance.collection("Favorite");
    await _collection.doc(userId).set({"contentIds": contentIdList});
  }
}
