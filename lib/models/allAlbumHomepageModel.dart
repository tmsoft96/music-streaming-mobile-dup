import 'package:flutter/foundation.dart';

class AllAlbumHomepageModel {
  bool? ok;
  String? msg;
  int? count;
  List<AllAlbumHomepageData>? data;

  AllAlbumHomepageModel({this.ok, this.msg, this.count, this.data});

  AllAlbumHomepageModel.fromJson({
    @required Map<String, dynamic>? json,
    @required String? httpMsg,
    @required String? filterByArtistId,
  }) {
    if (json != null) {
      ok = json['ok'];
      msg = json['msg'];
      count = json['count'];
      if (json['data'] != null) {
        List<AllAlbumHomepageData> data = <AllAlbumHomepageData>[];
        json['data'].forEach((v) {
          data.add(new AllAlbumHomepageData.fromJson(v));
        });
        this.data = <AllAlbumHomepageData>[];
        if (filterByArtistId != null)
          data.forEach((AllAlbumHomepageData d) {
            if (d.userid == filterByArtistId) this.data!.add(d);
          });
        else
          this.data = data;
      }
    } else {
      ok = false;
      msg = httpMsg;
      count = 0;
      data = null;
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

class AllAlbumHomepageData {
  int? id;
  String? urlHash;
  String? userid;
  String? stageName;
  String? name;
  String? cover;
  String? description;
  String? public;
  List<String>? tags;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? createuser;
  dynamic modifyuser;
  List<ContentFile>? files;
  Media? media;

  AllAlbumHomepageData({
    this.id,
    this.urlHash,
    this.userid,
    this.name,
    this.cover,
    this.description,
    this.public,
    this.tags,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createuser,
    this.modifyuser,
    this.files,
    this.stageName,
    this.media,
  });

  AllAlbumHomepageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    urlHash = json['url_hash'];
    userid = json['userid'];
    stageName = json['stage_name'] == null ? 'N/A' : json['stage_name'];
    name = json['name'];
    cover = json['cover'];
    description = json['description'];
    public = json['public'];
    tags = json['tags'] == null ? [] : json['tags'].cast<String>();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    createuser = json['createuser'];
    modifyuser = json['modifyuser'];
    if (json['files'] != null) {
      files = <ContentFile>[];
      json['files'].forEach((v) {
        files!.add(new ContentFile.fromJson(v));
      });
    }
    media = json['media'] != null ? new Media.fromJson(json['media']) : null;
    if (media != null) {
      cover = media!.thumb == "" ? cover : media!.thumb;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url_hash'] = this.urlHash;
    data['userid'] = this.userid;
    data['stage_name'] = this.stageName;
    data['name'] = this.name;
    data['cover'] = this.cover;
    data['description'] = this.description;
    data['public'] = this.public;
    data['tags'] = this.tags;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['createuser'] = this.createuser;
    data['modifyuser'] = this.modifyuser;
    if (this.files != null) {
      data['files'] = this.files!.map((v) => v.toJson()).toList();
    }
    if (this.media != null) {
      data['media'] = this.media!.toJson();
    }
    return data;
  }
}

// class TrackFiles {
//   int? id;
//   String? fileId;
//   String? albumId;
//   ContentFile? file;

//   TrackFiles({this.id, this.fileId, this.albumId, this.file});

//   TrackFiles.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     fileId = json['file_id'];
//     albumId = json['album_id'];
//     file = json['file'] != null ? new ContentFile.fromJson(json['file']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['file_id'] = this.fileId;
//     data['album_id'] = this.albumId;
//     if (this.file != null) {
//       data['file'] = this.file!.toJson();
//     }
//     return data;
//   }
// }

class ContentFile {
  int? id;
  String? userid;
  String? name;
  String? type;
  String? size;
  String? urlHash;
  String? filepath;
  dynamic cover;
  String? public;
  dynamic lyrics;

  ContentFile(
      {this.id,
      this.userid,
      this.name,
      this.type,
      this.size,
      this.urlHash,
      this.filepath,
      this.cover,
      this.public,
      this.lyrics});

  ContentFile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    name = json['name'];
    type = json['type'];
    size = json['size'];
    urlHash = json['url_hash'];
    filepath = json['filepath'];
    cover = json['cover'];
    public = json['public'];
    lyrics = json['lyrics'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['name'] = this.name;
    data['type'] = this.type;
    data['size'] = this.size;
    data['url_hash'] = this.urlHash;
    data['filepath'] = this.filepath;
    data['cover'] = this.cover;
    data['public'] = this.public;
    data['lyrics'] = this.lyrics;
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
