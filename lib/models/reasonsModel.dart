import 'package:flutter/foundation.dart';

class ReasonsModel {
  bool? ok;
  String? msg;
  int? count;
  List<String>? data;

  ReasonsModel({this.ok, this.msg, this.count, this.data});

  ReasonsModel.fromJson({
    @required Map<String, dynamic>? json,
    @required String? httpMsg,
  }) {
    if (json != null) {
      ok = json['ok'];
      msg = json['msg'];
      count = json['count'];
      data = json['data'].cast<String>();
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
    data['data'] = this.data;
    return data;
  }
}
