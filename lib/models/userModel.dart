class UserModel {
  bool? ok;
  String? msg;
  Data? data;

  UserModel({this.ok, this.msg, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? token;
  UserInfo? user;

  Data({this.token, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new UserInfo.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class UserInfo {
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
  dynamic phone;
  String? verified;
  String? lastLogin;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? createuser;
  dynamic modifyuser;
  List<Null>? followers;
  List<Null>? following;
  List<Null>? likes;
  List<Null>? downloads;
  List<Null>? favoriteAlbums;
  List<Null>? favoriteSongs;
  List<Null>? favoriteVideos;
  List<Null>? favoritePodcasts;
  List<Null>? folders;
  List<Null>? interests;
  List<Null>? schedules;

  UserInfo(
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
      this.modifyuser,
      this.followers,
      this.following,
      this.likes,
      this.downloads,
      this.favoriteAlbums,
      this.favoriteSongs,
      this.favoriteVideos,
      this.favoritePodcasts,
      this.folders,
      this.interests,
      this.schedules});

  UserInfo.fromJson(Map<String, dynamic> json) {
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
    // if (json['followers'] != null) {
    //   followers = <Null>[];
    //   json['followers'].forEach((v) {
    //     followers!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['following'] != null) {
    //   following = <Null>[];
    //   json['following'].forEach((v) {
    //     following!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['likes'] != null) {
    //   likes = <Null>[];
    //   json['likes'].forEach((v) {
    //     likes!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['downloads'] != null) {
    //   downloads = <Null>[];
    //   json['downloads'].forEach((v) {
    //     downloads!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['favorite_albums'] != null) {
    //   favoriteAlbums = <Null>[];
    //   json['favorite_albums'].forEach((v) {
    //     favoriteAlbums!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['favorite_songs'] != null) {
    //   favoriteSongs = <Null>[];
    //   json['favorite_songs'].forEach((v) {
    //     favoriteSongs!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['favorite_videos'] != null) {
    //   favoriteVideos = <Null>[];
    //   json['favorite_videos'].forEach((v) {
    //     favoriteVideos!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['favorite_podcasts'] != null) {
    //   favoritePodcasts = <Null>[];
    //   json['favorite_podcasts'].forEach((v) {
    //     favoritePodcasts!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['folders'] != null) {
    //   folders = <Null>[];
    //   json['folders'].forEach((v) {
    //     folders!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['interests'] != null) {
    //   interests = <Null>[];
    //   json['interests'].forEach((v) {
    //     interests!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['schedules'] != null) {
    //   schedules = <Null>[];
    //   json['schedules'].forEach((v) {
    //     schedules!.add(new Null.fromJson(v));
    //   });
    // }
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
    // if (this.followers != null) {
    //   data['followers'] = this.followers!.map((v) => v.toJson()).toList();
    // }
    // if (this.following != null) {
    //   data['following'] = this.following!.map((v) => v.toJson()).toList();
    // }
    // if (this.likes != null) {
    //   data['likes'] = this.likes!.map((v) => v.toJson()).toList();
    // }
    // if (this.downloads != null) {
    //   data['downloads'] = this.downloads!.map((v) => v.toJson()).toList();
    // }
    // if (this.favoriteAlbums != null) {
    //   data['favorite_albums'] =
    //       this.favoriteAlbums!.map((v) => v.toJson()).toList();
    // }
    // if (this.favoriteSongs != null) {
    //   data['favorite_songs'] =
    //       this.favoriteSongs!.map((v) => v.toJson()).toList();
    // }
    // if (this.favoriteVideos != null) {
    //   data['favorite_videos'] =
    //       this.favoriteVideos!.map((v) => v.toJson()).toList();
    // }
    // if (this.favoritePodcasts != null) {
    //   data['favorite_podcasts'] =
    //       this.favoritePodcasts!.map((v) => v.toJson()).toList();
    // }
    // if (this.folders != null) {
    //   data['folders'] = this.folders!.map((v) => v.toJson()).toList();
    // }
    // if (this.interests != null) {
    //   data['interests'] = this.interests!.map((v) => v.toJson()).toList();
    // }
    // if (this.schedules != null) {
    //   data['schedules'] = this.schedules!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
