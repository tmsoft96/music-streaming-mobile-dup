import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rally/config/hiveStorage.dart';
import 'package:rally/providers/allDownloadProvider.dart';

class AllDownloadModel {
  List<AllDownloadData>? data;

  AllDownloadModel({this.data});

  AllDownloadModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AllDownloadData>[];
      json['data'].forEach((v) {
        data!.add(new AllDownloadData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllDownloadData {
  String? id;
  String? cover;
  String? title;
  List<AllDownloadContent>? content;
  String? artistName;
  String? description;
  int? createAt;
  String? contentType;
  bool? fileDownloaded;

  AllDownloadData({
    this.id,
    this.cover,
    this.title,
    this.content,
    this.artistName,
    this.createAt,
    this.description,
    this.contentType,
    this.fileDownloaded,
  });

  AllDownloadData.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    cover = json['cover'];
    title = json['title'];
    artistName = json['artistName'] ?? "N/A";
    createAt = json['createAt'];
    description = json['description'] ?? "N/A";
    if (json['content'] != null) {
      content = <AllDownloadContent>[];
      json['content'].forEach((v) {
        content!.add(new AllDownloadContent.fromJson(v));
      });
    }
    contentType = id!.contains("banner")
        ? "banner"
        : id!.contains("playlist")
            ? "playlist"
            : id!.contains("album")
                ? "album"
                : "single";
    fileDownloaded = json['fileDownloaded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cover'] = this.cover;
    data['title'] = this.title;
    data['artistName'] = this.artistName;
    data['createAt'] = this.createAt;
    data['description'] = this.description;
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data["contentType"] = this.contentType;
    data["fileDownloaded"] = this.fileDownloaded;
    return data;
  }
}

class AllDownloadContent {
  String? id;
  String? title;
  String? lyrics;
  String? stageName;
  String? filepath;
  String? cover;
  String? thumbnail;
  bool? isCoverLocal;
  String? description;
  String? artistId;
  bool? downloaded;
  String? localFilePath;
  bool? isDownloading;
  double? percentDownloadCompleteValue;

  AllDownloadContent({
    this.id,
    this.title,
    this.lyrics,
    this.stageName,
    this.filepath,
    this.cover,
    this.thumbnail,
    this.isCoverLocal,
    this.artistId,
    this.description,
    this.downloaded,
    this.localFilePath,
    this.isDownloading,
    this.percentDownloadCompleteValue,
  });

  AllDownloadContent.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    title = json['title'];
    lyrics = json['lyrics'];
    stageName = json['stageName'];
    filepath = json['filepath'];
    cover = json['cover'];
    thumbnail = json['thumbnail'] ?? "";
    isCoverLocal = json['isCoverLocal'];
    description = json['description'];
    artistId = json["artistId"];
    downloaded = json["downloaded"];
    localFilePath = json["localFile"] ?? "";
    File(localFilePath!).exists().then((value) {
      print("exit $value");
    });
    percentDownloadCompleteValue = 0;
    isDownloading = json["isDownloading"] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['lyrics'] = this.lyrics;
    data['stageName'] = this.stageName;
    data['filepath'] = this.filepath;
    data['cover'] = this.cover;
    data['thumbnail'] = this.thumbnail;
    data['isCoverLocal'] = this.isCoverLocal;
    data['description'] = this.description;
    data["artistId"] = this.artistId;
    data["localFile"] = this.localFilePath;
    data["downloaded"] = this.downloaded;
    data["percentDownloadCompleteValue"] = this.percentDownloadCompleteValue;
    data["isDownloading"] = this.isDownloading;
    return data;
  }
}

AllDownloadModel allDownloadMakedownload({
  @required AllDownloadModel? model,
  @required int? index,
  @required int? contentIndex,
  @required double? percentDownloadCompleteValue,
}) {
  model!.data![index!].content![contentIndex!].isDownloading = true;
  model.data![index].content![contentIndex].percentDownloadCompleteValue =
      percentDownloadCompleteValue;
  return model;
}

Future<AllDownloadModel> allDownloadDownloadComplete({
  @required AllDownloadModel? model,
  @required String? localFilePath,
  @required int? index,
  @required int? contentIndex,
}) async {
  model!.data![index!].content![contentIndex!].isDownloading = false;
  model.data![index].content![contentIndex].downloaded = true;
  model.data![index].content![contentIndex].localFilePath = localFilePath;
  model.data![index].content![contentIndex].percentDownloadCompleteValue = 100;

  bool saveData = true;
  for (var data in model.data!) {
    for (var content in data.content!) {
      if (!content.downloaded!) {
        saveData = false;
        break;
      }
    }
  }

  if (saveData) {
    model.data![index].fileDownloaded = true;
    ongoingDownload = false;

    await saveHive(
      key: "downloadFiles",
      data: json.encode(model.toJson()["data"]),
    );
  }

  return model;
}

AllDownloadModel allDownloadAddDowonloadInfo({
  @required AllDownloadModel? model,
  @required List<Map<dynamic, dynamic>>? newDataList,
}) {
  for (var data in newDataList!) {
    model!.data!.add(AllDownloadData.fromJson(data));
  }
  return model!;
}
