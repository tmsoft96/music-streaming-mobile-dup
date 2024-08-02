import 'package:flutter/foundation.dart';

class AllGenreModel {
  bool? ok;
  String? msg;
  int? count;
  List<AllGenreData>? data;

  AllGenreModel({this.ok, this.msg, this.count, this.data});

  AllGenreModel.fromJson({
    @required Map<String, dynamic>? json,
    @required String? httpMsg,
  }) {
    if (json != null) {
      ok = json['ok'];
      msg = json['msg'];
      count = json['count'];
      if (json['data'] != null) {
        data = <AllGenreData>[];
        json['data'].forEach((v) {
          data!.add(new AllGenreData.fromJson(v));
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

class AllGenreData {
  int? id;
  String? name;
  String? cover;
  String? urlHash;
  bool? selected;

  AllGenreData({
    this.id,
    this.name,
    this.cover,
    this.urlHash,
    this.selected,
  });

  AllGenreData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cover = json['cover'];
    urlHash = json['url_hash'];
    selected = false;
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

void selectAllGenreData({
  @required AllGenreModel? model,
  @required int? index,
}) {
  for (var data in model!.data!) data.selected = false;
  model.data![index!].selected = true;
}
