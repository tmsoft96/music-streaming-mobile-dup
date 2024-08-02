import 'package:flutter/foundation.dart';
import 'package:rally/config/checkSession.dart';

class AllMusicTopPicksModel {
  bool? ok;
  String? msg;
  int? count;
  int? totalStream;
  List<MusicData>? data;

  AllMusicTopPicksModel({
    this.ok,
    this.msg,
    this.count,
    this.data,
    this.totalStream,
  });

  AllMusicTopPicksModel.fromJson({
    @required Map<String, dynamic>? json,
    @required String? httpMsg,
  }) {
    if (json != null) {
      ok = json['ok'];
      msg = json['msg'];
      count = json['count'];
      if (json['data'] != null) {
        List<MusicData> data = <MusicData>[];
        json['data'].forEach((v) {
          data.add(new MusicData.fromJson(v));
        });
        this.data = <MusicData>[];
        totalStream = 0;
        data.forEach((MusicData d) {
          totalStream =
              totalStream! + (d.streams == null ? 0 : d.streams!.length);
        });
        this.data = data;
      }
    } else {
      ok = false;
      msg = httpMsg;
      count = 0;
      data = [];
      totalStream = 0;
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

class MusicData {
  int? id;
  String? userid;
  String? type;
  String? title;
  dynamic lyrics;
  List<String>? tags;
  String? stageName;
  String? filepath;
  String? cover;
  String? public;
  String? description;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  User? user;
  List<Genres>? genres;
  List<Comments>? comments;
  List<Ratings>? ratings;
  List<Likes>? likes;
  List<Downloads>? downloads;
  List<Streams>? streams;
  Media? media;
  double? totalRate;
  double? oneRate;
  double? twoRate;
  double? threeRate;
  double? fourRate;
  double? fiveRate;
  double? currentListenerRate;

  MusicData({
    this.id,
    this.userid,
    this.type,
    this.title,
    this.lyrics,
    this.tags,
    this.stageName,
    this.filepath,
    this.cover,
    this.public,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
    this.genres,
    this.comments,
    this.ratings,
    this.likes,
    this.downloads,
    this.streams,
    this.totalRate,
    this.fiveRate,
    this.fourRate,
    this.oneRate,
    this.threeRate,
    this.twoRate,
    this.currentListenerRate,
    this.media,
  });

  MusicData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    type = json['type'];
    title = json['title'];
    lyrics = json['lyrics'];
    tags = json['tags'] == null ? [] : json['tags'].cast<String>();
    stageName = json['stage_name'];
    filepath = json['filepath'];
    cover = json['cover'];
    public = json['public'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['genres'] != null) {
      genres = <Genres>[];
      json['genres'].forEach((v) {
        genres!.add(new Genres.fromJson(v));
      });
    }
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
    totalRate = .0;
    oneRate = .0;
    twoRate = .0;
    threeRate = .0;
    fourRate = .0;
    fiveRate = .0;
    currentListenerRate = 0;
    if (json['ratings'] != null) {
      ratings = <Ratings>[];
      json['ratings'].forEach((v) {
        ratings!.add(new Ratings.fromJson(v));
      });
      for (Ratings rating in ratings!) {
        if (rating.rating == "1") oneRate = oneRate! + (1 * 1);
        if (rating.rating == "2") twoRate = twoRate! + (1 * 2);
        if (rating.rating == "3") threeRate = threeRate! + (1 * 3);
        if (rating.rating == "4") fourRate = fourRate! + (1 * 4);
        if (rating.rating == "5") fiveRate = fiveRate! + (1 * 5);
        if (userModel != null &&
            (rating.userid == userModel!.data!.user!.userid))
          currentListenerRate = double.parse(rating.rating!);
      }
      totalRate = (oneRate! + twoRate! + threeRate! + fourRate! + fiveRate!) /
          ratings!.length;
    }

    if (json['likes'] != null) {
      likes = <Likes>[];
      json['likes'].forEach((v) {
        likes!.add(new Likes.fromJson(v));
      });
    }
    if (json['downloads'] != null) {
      downloads = <Downloads>[];
      json['downloads'].forEach((v) {
        downloads!.add(new Downloads.fromJson(v));
      });
    }
    if (json['streams'] != null) {
      streams = <Streams>[];
      json['streams'].forEach((v) {
        streams!.add(new Streams.fromJson(v));
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
    data['userid'] = this.userid;
    data['type'] = this.type;
    data['title'] = this.title;
    data['lyrics'] = this.lyrics;
    data['tags'] = this.tags;
    data['stage_name'] = this.stageName;
    data['filepath'] = this.filepath;
    data['cover'] = this.cover;
    data['public'] = this.public;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.genres != null) {
      data['genres'] = this.genres!.map((v) => v.toJson()).toList();
    }
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    if (this.ratings != null) {
      data['ratings'] = this.ratings!.map((v) => v.toJson()).toList();
    }
    if (this.likes != null) {
      data['likes'] = this.likes!.map((v) => v.toJson()).toList();
    }
    if (this.downloads != null) {
      data['downloads'] = this.downloads!.map((v) => v.toJson()).toList();
    }
    if (this.streams != null) {
      data['streams'] = this.streams!.map((v) => v.toJson()).toList();
    }
    if (this.media != null) {
      data['media'] = this.media!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? urlHash;
  String? fname;
  String? lname;
  dynamic mname;
  dynamic stageName;
  String? name;
  String? username;
  String? userid;
  String? email;
  String? emailVerifiedAt;
  String? role;
  String? picture;
  String? twoStep;
  dynamic country;
  dynamic gender;
  dynamic bio;
  dynamic dob;
  String? phone;
  String? verified;
  String? lastLogin;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? createuser;
  String? modifyuser;

  User(
      {this.id,
      this.urlHash,
      this.fname,
      this.lname,
      this.mname,
      this.stageName,
      this.name,
      this.username,
      this.userid,
      this.email,
      this.emailVerifiedAt,
      this.role,
      this.picture,
      this.twoStep,
      this.country,
      this.gender,
      this.bio,
      this.dob,
      this.phone,
      this.verified,
      this.lastLogin,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.createuser,
      this.modifyuser});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    urlHash = json['url_hash'];
    fname = json['fname'];
    lname = json['lname'];
    mname = json['mname'];
    stageName = json['stage_name'];
    name = json['name'];
    username = json['username'];
    userid = json['userid'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    role = json['role'];
    picture = json['picture'];
    twoStep = json['two_step'];
    country = json['country'];
    gender = json['gender'];
    bio = json['bio'];
    dob = json['dob'];
    phone = json['phone'];
    verified = json['verified'];
    lastLogin = json['last_login'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    createuser = json['createuser'];
    modifyuser = json['modifyuser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url_hash'] = this.urlHash;
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['mname'] = this.mname;
    data['stage_name'] = this.stageName;
    data['name'] = this.name;
    data['username'] = this.username;
    data['userid'] = this.userid;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['role'] = this.role;
    data['picture'] = this.picture;
    data['two_step'] = this.twoStep;
    data['country'] = this.country;
    data['gender'] = this.gender;
    data['bio'] = this.bio;
    data['dob'] = this.dob;
    data['phone'] = this.phone;
    data['verified'] = this.verified;
    data['last_login'] = this.lastLogin;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['createuser'] = this.createuser;
    data['modifyuser'] = this.modifyuser;
    return data;
  }
}

class Genres {
  int? id;
  String? genreId;
  Genre? genre;

  Genres({this.id, this.genreId, this.genre});

  Genres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    genreId = json['genre_id'];
    genre = json['genre'] != null ? new Genre.fromJson(json['genre']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['genre_id'] = this.genreId;
    if (this.genre != null) {
      data['genre'] = this.genre!.toJson();
    }
    return data;
  }
}

class Genre {
  int? id;
  String? name;
  String? cover;
  String? urlHash;

  Genre({this.id, this.name, this.cover, this.urlHash});

  Genre.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cover = json['cover'];
    urlHash = json['url_hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cover'] = this.cover;
    data['url_hash'] = this.urlHash;
    return data;
  }
}

class Comments {
  int? id;
  String? userid;
  String? postId;
  String? content;
  String? parentId;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  User? user;
  List<Null>? children;
  List<Null>? allChildren;

  Comments(
      {this.id,
      this.userid,
      this.postId,
      this.content,
      this.parentId,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.children,
      this.allChildren});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    postId = json['post_id'];
    content = json['content'];
    parentId = json['parent_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    // if (json['children'] != null) {
    //   children = <Null>[];
    //   json['children'].forEach((v) {
    //     children!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['all_children'] != null) {
    //   allChildren = <Null>[];
    //   json['all_children'].forEach((v) {
    //     allChildren!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['post_id'] = this.postId;
    data['content'] = this.content;
    data['parent_id'] = this.parentId;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    // if (this.children != null) {
    //   data['children'] = this.children!.map((v) => v.toJson()).toList();
    // }
    // if (this.allChildren != null) {
    //   data['all_children'] = this.allChildren!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Ratings {
  String? userid;
  String? postId;
  String? rating;
  User? user;

  Ratings({this.userid, this.postId, this.rating, this.user});

  Ratings.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    postId = json['post_id'];
    rating = json['rating'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['post_id'] = this.postId;
    data['rating'] = this.rating;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Likes {
  int? id;
  String? userid;
  String? postId;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Likes(
      {this.id,
      this.userid,
      this.postId,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  Likes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    postId = json['post_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['post_id'] = this.postId;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Downloads {
  int? id;
  String? userid;
  String? postId;
  String? type;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  Downloads(
      {this.id,
      this.userid,
      this.postId,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Downloads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    postId = json['post_id'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['post_id'] = this.postId;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Streams {
  String? userid;
  User? user;

  Streams({this.userid, this.user});

  Streams.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
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
