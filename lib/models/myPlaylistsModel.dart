import 'package:flutter/foundation.dart';

class MyPlaylistsModel {
  bool? ok;
  String? msg;
  int? count;
  List<MyPlaylistsData>? data;

  MyPlaylistsModel({this.ok, this.msg, this.count, this.data});

  MyPlaylistsModel.fromJson({
    @required Map<String, dynamic>? json,
    @required String? httpMsg,
  }) {
    if (json != null) {
      ok = json['ok'];
      msg = json['msg'];
      count = json['count'];
      if (json['data'] != null) {
        data = <MyPlaylistsData>[];
        json['data'].forEach((v) {
          data!.add(new MyPlaylistsData.fromJson(v));
        });
      }
    } else {
      ok = false;
      msg = httpMsg;
      count = 0;
      data = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    data['msg'] = this.msg;
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyPlaylistsData {
  int? id;
  String? userid;
  String? title;
  String? cover;
  String? description;
  String? public;
  List<String>? genres;
  String? createdAt;
  List<Content>? content;
  Media? media;
  User? user;

  MyPlaylistsData(
      {this.id,
      this.userid,
      this.title,
      this.cover,
      this.description,
      this.public,
      this.genres,
      this.createdAt,
      this.content,
      this.media,
      this.user});

  MyPlaylistsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    title = json['title'];
    cover = json['cover'];
    description = json['description'];
    public = json['public'];
    genres = json['genres'] != null ? json['genres'].cast<String>() : [];
    createdAt = json['created_at'];
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(new Content.fromJson(v));
      });
    }
    media = json['media'] != null ? new Media.fromJson(json['media']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['title'] = this.title;
    data['cover'] = this.cover;
    data['description'] = this.description;
    data['public'] = this.public;
    data['genres'] = this.genres;
    data['created_at'] = this.createdAt;
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    if (this.media != null) {
      data['media'] = this.media!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Content {
  String? id;
  String? userid;
  String? stageName;
  String? type;
  String? title;
  String? lyrics;
  String? filepath;
  String? cover;
  String? public;
  List<String>? tags;
  dynamic description;

  Content({
    this.id,
    this.userid,
    this.stageName,
    this.type,
    this.title,
    this.filepath,
    this.cover,
    this.public,
    this.tags,
    this.description,
    this.lyrics,
  });

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    stageName = json['stage_name'];
    type = json['type'];
    title = json['title'];
    filepath = json['filepath'];
    cover = json['cover'];
    public = json['public'];
    tags = json['tags'].cast<String>();
    description = json['description'];
    lyrics = json['lyrics'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['stage_name'] = this.stageName;
    data['type'] = this.type;
    data['title'] = this.title;
    data['filepath'] = this.filepath;
    data['cover'] = this.cover;
    data['public'] = this.public;
    data['tags'] = this.tags;
    data['description'] = this.description;
    return data;
  }
}

class Media {
  String? thumb;
  String? standard;
  String? normal;
  String? thumbCropped;
  String? raw;
  String? thumbnail;

  Media({
    this.thumb,
    this.standard,
    this.normal,
    this.thumbCropped,
    this.raw,
    this.thumbnail,
  });

  Media.fromJson(Map<String, dynamic> json) {
    raw = json['raw'];
    thumb = json['thumb'] != null && json['thumb'] != "" ? json['thumb'] : raw;
    standard = json['standard'] != "" ? json['standard'] : raw;
    normal =
        json['normal'] != null && json['normal'] != "" ? json['normal'] : raw;
    thumbCropped = json['thumb-cropped'] != "" ? json['thumb-cropped'] : raw;
    thumbnail = json['thumbnail'] != "" ? json['thumbnail'] : raw;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['thumb'] = this.thumb;
    data['standard'] = this.standard;
    data['normal'] = this.normal;
    data['thumb-cropped'] = this.thumbCropped;
    data['raw'] = this.raw;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}

class User {
  String? userid;
  String? fname;
  dynamic mname;
  String? lname;
  String? stageName;
  String? name;
  String? picture;
  String? email;
  String? phone;

  User({
    this.userid,
    this.fname,
    this.mname,
    this.lname,
    this.stageName,
    this.picture,
    this.email,
    this.phone,
    this.name,
  });

  User.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    fname = json['fname'];
    mname = json['mname'];
    lname = json['lname'];
    stageName = json['stage_name'];
    name = json['name'];
    picture = json['picture'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['fname'] = this.fname;
    data['mname'] = this.mname;
    data['lname'] = this.lname;
    data['stage_name'] = this.stageName;
    data['picture'] = this.picture;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}
