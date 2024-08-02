import 'package:flutter/foundation.dart';

class AllBannersModel {
  bool? ok;
  String? msg;
  int? count;
  List<AllBannersData>? data;

  AllBannersModel({this.ok, this.msg, this.count, this.data});

  AllBannersModel.fromJson({
    @required Map<String, dynamic>? json,
    @required String? httpMsg,
  }) {
    if (json != null) {
      ok = json['ok'];
      msg = json['msg'];
      count = json['count'];
      if (json['data'] != null) {
        data = <AllBannersData>[];
        json['data'].forEach((v) {
          data!.add(new AllBannersData.fromJson(v));
        });
      }
    } else {
      ok = false;
      msg = httpMsg;
      data = null;
      count = 0;
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

class AllBannersData {
  int? id;
  String? cover;
  String? title;
  dynamic startdate;
  dynamic enddate;
  int? status;
  List<Files>? files;
  int? content;
  Media? media;
  String? dateCreated;

  AllBannersData({
    this.id,
    this.cover,
    this.title,
    this.files,
    this.dateCreated,
    this.content,
    this.enddate,
    this.media,
    this.startdate,
    this.status,
  });

  AllBannersData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cover = json['cover'];
    title = json['title'];
    startdate = json['startdate'];
    enddate = json['enddate'];
    status = json['status'];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(new Files.fromJson(v));
      });
    }
    content = json['content'];
    media = json['media'] != null ? new Media.fromJson(json['media']) : null;
    dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cover'] = this.cover;
    data['title'] = this.title;
    data['startdate'] = this.startdate;
    data['enddate'] = this.enddate;
    data['status'] = this.status;
    if (this.files != null) {
      data['files'] = this.files!.map((v) => v.toJson()).toList();
    }
    data['content'] = this.content;
    if (this.media != null) {
      data['media'] = this.media!.toJson();
    }
    data['date_created'] = this.dateCreated;
    return data;
  }
}

class Files {
  dynamic id;
  String? userid;
  String? stageName;
  String? type;
  String? title;
  String? filepath;
  String? cover;
  Media? media;
  String? public;
  List<String>? tags;
  String? description;

  Files({
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
    this.media,
  });

  Files.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    stageName = json['stage_name'];
    type = json['type'];
    title = json['title'];
    filepath = json['filepath'];
    cover = json['cover'];
    media = json['media'] != null ? new Media.fromJson(json['media']) : null;
    public = json['public'];
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    description = json['description'];
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
    if (this.media != null) {
      data['media'] = this.media!.toJson();
    }
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
