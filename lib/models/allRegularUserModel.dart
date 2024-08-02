import 'package:flutter/foundation.dart';

class AllRegularUserModel {
  bool? ok;
  String? msg;
  int? count;
  List<Data>? data;

  AllRegularUserModel({this.ok, this.msg, this.count, this.data});

  AllRegularUserModel.fromJson({
    @required Map<String, dynamic>? json,
    @required String? httpMsg,
  }) {
    if (json != null) {
      ok = json['ok'];
      msg = json['msg'];
      count = json['count'];
      if (json['data'] != null) {
        data = <Data>[];
        json['data'].forEach((v) {
          data!.add(new Data.fromJson(v));
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

class Data {
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
  List<Followers>? followers;
  List<Followers>? following;

  Data(
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
      this.following});

  Data.fromJson(Map<String, dynamic> json) {
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
    if (this.followers != null) {
      data['followers'] = this.followers!.map((v) => v.toJson()).toList();
    }
    if (this.following != null) {
      data['following'] = this.following!.map((v) => v.toJson()).toList();
    }
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
  User? user;

  Followers(
      {this.id,
      this.userid,
      this.followerId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.user});

  Followers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    followerId = json['follower_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['follower_id'] = this.followerId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
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
  String? stageName;
  String? name;
  String? username;
  String? userid;
  String? email;
  String? emailVerifiedAt;
  String? role;
  String? picture;
  String? twoStep;
  dynamic country;
  String? gender;
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
