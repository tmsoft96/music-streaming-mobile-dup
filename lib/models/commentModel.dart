import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rally/config/checkSession.dart';

class CommentModel {
  List<CommentData>? data;

  CommentModel({this.data});

  CommentModel.fromJson(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> json,
  ) {
    List<CommentData> data = <CommentData>[];
    json.forEach((value) {
      print(value.data());
      data.add(new CommentData.fromJson(value.data()));
    });
    data.sort(((a, b) {
      return b.createdDate!.compareTo(a.createdDate!);
    }));

    this.data = data;
    print("length ${this.data!.length}");
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (this.data != null) {
      data['data'] =
          this.data!.map((CommentData data) => data.toJson()).toList();
    }
    return data;
  }
}

class CommentData {
  String? profilePicture;
  Timestamp? createdDate;
  String? contentId;
  String? commentId;
  String? name;
  String? comment;
  String? userId;
  int? delete;
  List<String>? likeReaction;
  List<String>? unlikeReaction;
  bool? isLike;
  bool? isUnlike;

  CommentData({
    this.profilePicture,
    this.createdDate,
    this.contentId,
    this.name,
    this.comment,
    this.userId,
    this.delete,
    this.likeReaction,
    this.unlikeReaction,
    this.commentId,
    this.isLike,
    this.isUnlike,
  });

  CommentData.fromJson(Map<String, dynamic> json) {
    profilePicture = json['profilePicture'];
    createdDate = json['createdDate'];
    contentId = json['contentId'];
    name = json['name'];
    comment = json['comment'];
    commentId = json['commentId'];
    userId = json['userId'];
    delete = json['delete'];
    likeReaction =
        json['likeReaction'] == null ? [] : json['likeReaction'].cast<String>();
    unlikeReaction = json['unlikeReaction'] == null
        ? []
        : json['unlikeReaction'].cast<String>();
    isLike = likeReaction!.indexOf(userModel!.data!.user!.userid!) != -1;
    isUnlike = unlikeReaction!.indexOf(userModel!.data!.user!.userid!) != -1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profilePicture'] = this.profilePicture;
    data['createdDate'] = this.createdDate;
    data['contentId'] = this.contentId;
    data['commentId'] = this.commentId;
    data['name'] = this.name;
    data['comment'] = this.comment;
    data['userId'] = this.userId;
    data['delete'] = this.delete;
    return data;
  }
}
