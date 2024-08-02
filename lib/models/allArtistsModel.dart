import 'package:flutter/foundation.dart';

class AllArtistsModel {
  bool? ok;
  String? msg;
  int? count;
  List<AllArtistData>? data;

  AllArtistsModel({this.ok, this.msg, this.count, this.data});

  AllArtistsModel.fromJson({
    @required Map<String, dynamic>? json,
    @required String? httpMsg,
  }) {
    if (json != null) {
      ok = json['ok'];
      msg = json['msg'];
      count = json['count'];
      if (json['data'] != null) {
        data = <AllArtistData>[];
        json['data'].forEach((v) {
          data!.add(new AllArtistData.fromJson(v));
        });
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

class AllArtistData {
  int? id;
  String? urlHash;
  String? fname;
  String? lname;
  String? mname;
  String? stageName;
  String? name;
  String? username;
  String? userid;
  String? email;
  dynamic email2;
  String? emailVerifiedAt;
  String? role;
  dynamic twitterId;
  String? picture;
  String? lastLogin;
  String? twoStep;
  String? twoStepType;
  String? twoStepContact;
  String? country;
  String? gender;
  String? bio;
  String? dob;
  String? phone;
  dynamic communication;
  String? verified;
  String? isNotified;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? createuser;
  String? modifyuser;
  String? postsCount;
  String? followersCount;
  String? followingCount;
  String? streamsCount;
  List<Genres>? genres;
  List<Followers>? followers;
  List<Followers>? following;
  List<Streams>? streams;

  AllArtistData(
      {@required this.id,
      @required this.urlHash,
      @required this.fname,
      @required this.lname,
      @required this.mname,
      @required this.stageName,
      @required this.name,
      @required this.username,
      @required this.userid,
      @required this.email,
      @required this.email2,
      @required this.emailVerifiedAt,
      @required this.role,
      @required this.twitterId,
      @required this.picture,
      @required this.lastLogin,
      @required this.twoStep,
      @required this.twoStepType,
      @required this.twoStepContact,
      @required this.country,
      @required this.gender,
      @required this.bio,
      @required this.dob,
      @required this.phone,
      @required this.communication,
      @required this.verified,
      @required this.isNotified,
      @required this.createdAt,
      @required this.updatedAt,
      @required this.deletedAt,
      @required this.createuser,
      @required this.modifyuser,
      @required this.postsCount,
      @required this.followersCount,
      @required this.followingCount,
      @required this.streamsCount,
      @required this.genres,
      @required this.followers,
      @required this.following,
      @required this.streams});

  AllArtistData.fromJson(Map<String, dynamic> json) {
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
    email2 = json['email2'];
    emailVerifiedAt = json['email_verified_at'];
    role = json['role'];
    twitterId = json['twitter_id'];
    picture = json['picture'];
    lastLogin = json['last_login'];
    twoStep = json['two_step'];
    twoStepType = json['two_step_type'];
    twoStepContact = json['two_step_contact'];
    country = json['country'];
    gender = json['gender'];
    bio = json['bio'];
    dob = json['dob'];
    phone = json['phone'];
    communication = json['communication'];
    verified = json['verified'];
    isNotified = json['isNotified'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    createuser = json['createuser'];
    modifyuser = json['modifyuser'];
    postsCount = json['posts_count'];
    followersCount = json['followers_count'];
    followingCount = json['following_count'];
    streamsCount = json['streams_count'];
    if (json['genres'] != null) {
      genres = <Genres>[];
      json['genres'].forEach((v) {
        genres!.add(new Genres.fromJson(v));
      });
    }
    if (json['followers'] != null) {
      followers = <Followers>[];
      json['followers'].forEach((v) {
        followers!.add(new Followers.fromJson(v));
      });
    }
    if (json['following'] != null) {
      following = <Followers>[];
      json['following'].forEach((v) {
        following!.add(new Followers.fromJson(v));
      });
    }
    if (json['streams'] != null) {
      streams = <Streams>[];
      json['streams'].forEach((v) {
        streams!.add(new Streams.fromJson(v));
      });
    }
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
    data['email2'] = this.email2;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['role'] = this.role;
    data['twitter_id'] = this.twitterId;
    data['picture'] = this.picture;
    data['last_login'] = this.lastLogin;
    data['two_step'] = this.twoStep;
    data['two_step_type'] = this.twoStepType;
    data['two_step_contact'] = this.twoStepContact;
    data['country'] = this.country;
    data['gender'] = this.gender;
    data['bio'] = this.bio;
    data['dob'] = this.dob;
    data['phone'] = this.phone;
    data['communication'] = this.communication;
    data['verified'] = this.verified;
    data['isNotified'] = this.isNotified;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['createuser'] = this.createuser;
    data['modifyuser'] = this.modifyuser;
    data['posts_count'] = this.postsCount;
    data['followers_count'] = this.followersCount;
    data['following_count'] = this.followingCount;
    data['streams_count'] = this.streamsCount;
    if (this.genres != null) {
      data['genres'] = this.genres!.map((v) => v.toJson()).toList();
    }
    if (this.followers != null) {
      data['followers'] = this.followers!.map((v) => v.toJson()).toList();
    }
    if (this.following != null) {
      data['following'] = this.following!.map((v) => v.toJson()).toList();
    }
    if (this.streams != null) {
      data['streams'] = this.streams!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Genres {
  int? id;
  String? genreId;
  String? userid;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  Genre? genre;

  Genres(
      {this.id,
      this.genreId,
      this.userid,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.genre});

  Genres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    genreId = json['genre_id'];
    userid = json['userid'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    genre = json['genre'] != null ? new Genre.fromJson(json['genre']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['genre_id'] = this.genreId;
    data['userid'] = this.userid;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
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
  String? public;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? createuser;
  dynamic modifyuser;

  Genre(
      {this.id,
      this.name,
      this.cover,
      this.urlHash,
      this.public,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.createuser,
      this.modifyuser});

  Genre.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cover = json['cover'];
    urlHash = json['url_hash'];
    public = json['public'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    createuser = json['createuser'];
    modifyuser = json['modifyuser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cover'] = this.cover;
    data['url_hash'] = this.urlHash;
    data['public'] = this.public;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['createuser'] = this.createuser;
    data['modifyuser'] = this.modifyuser;
    return data;
  }
}

class Followers {
  int? id;
  String? userid;
  String? followerId;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  Followers(
      {this.id,
      this.userid,
      this.followerId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Followers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    followerId = json['follower_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['follower_id'] = this.followerId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Streams {
  int? id;
  String? postId;
  String? artistId;
  String? userid;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  Post? post;
  dynamic artist;

  Streams(
      {this.id,
      this.postId,
      this.artistId,
      this.userid,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.post,
      this.artist});

  Streams.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    artistId = json['artist_id'];
    userid = json['userid'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    post = json['post'] != null ? new Post.fromJson(json['post']) : null;
    artist = json['artist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_id'] = this.postId;
    data['artist_id'] = this.artistId;
    data['userid'] = this.userid;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.post != null) {
      data['post'] = this.post!.toJson();
    }
    data['artist'] = this.artist;
    return data;
  }
}

class Post {
  int? id;
  String? userid;
  dynamic albumId;
  String? type;
  String? title;
  String? lyrics;
  String? stageName;
  String? filepath;
  String? cover;
  String? size;
  String? public;
  dynamic startDate;
  dynamic timezone;
  String? duration;
  List<String>? tags;
  String? description;
  String? isNotified;
  String? createuser;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  Post(
      {this.id,
      this.userid,
      this.albumId,
      this.type,
      this.title,
      this.lyrics,
      this.stageName,
      this.filepath,
      this.cover,
      this.size,
      this.public,
      this.startDate,
      this.timezone,
      this.duration,
      this.tags,
      this.description,
      this.isNotified,
      this.createuser,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    albumId = json['album_id'];
    type = json['type'];
    title = json['title'];
    lyrics = json['lyrics'];
    stageName = json['stage_name'];
    filepath = json['filepath'];
    cover = json['cover'];
    size = json['size'];
    public = json['public'];
    startDate = json['start_date'];
    timezone = json['timezone'];
    duration = json['duration'];
    tags = json['tags'] == null ? [] : json['tags'].cast<String>();
    description = json['description'];
    isNotified = json['isNotified'];
    createuser = json['createuser'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['album_id'] = this.albumId;
    data['type'] = this.type;
    data['title'] = this.title;
    data['lyrics'] = this.lyrics;
    data['stage_name'] = this.stageName;
    data['filepath'] = this.filepath;
    data['cover'] = this.cover;
    data['size'] = this.size;
    data['public'] = this.public;
    data['start_date'] = this.startDate;
    data['timezone'] = this.timezone;
    data['duration'] = this.duration;
    data['tags'] = this.tags;
    data['description'] = this.description;
    data['isNotified'] = this.isNotified;
    data['createuser'] = this.createuser;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
