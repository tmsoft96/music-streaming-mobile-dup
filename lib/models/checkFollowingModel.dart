import 'package:flutter/foundation.dart';

class CheckFollowingModel {
  bool? ok;
  String? msg;
  int? data;

  CheckFollowingModel({this.ok, this.msg, this.data});

  CheckFollowingModel.fromJson({
    @required Map<String, dynamic>? json,
    @required String? httpMsg,
  }) {
    if (json != null) {
      ok = json['ok'];
      msg = json['msg'];
      data = json['data'];
    } else {
      ok = false;
      msg = httpMsg;
      data = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    data['msg'] = this.msg;
    data['data'] = this.data;
    return data;
  }
}
