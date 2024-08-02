class QueueModel {
  List<QueueData>? data;

  QueueModel({this.data});

  QueueModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <QueueData>[];
      json['data'].forEach((v) {
        data!.add(new QueueData.fromJson(v));
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

class QueueData {
  String? id;
  String? title;
  String? lyrics;
  String? stageName;
  String? filepath;
  String? cover;
  String? thumb;
  String? thumbnail;
  bool? isCoverLocal;
  String? description;
  List<String>? tags;
  String? artistId;
  bool? isFileLocal;

  QueueData({
    this.id,
    this.title,
    this.lyrics,
    this.stageName,
    this.filepath,
    this.cover,
    this.thumb,
    this.thumbnail,
    this.isCoverLocal,
    this.description,
    this.tags,
    this.artistId,
    this.isFileLocal,
  });

  QueueData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    title = json['title'];
    lyrics = json['lyrics'];
    stageName = json['stageName'];
    filepath = json['filepath'];
    cover = json['cover'];
    thumb = json['thumb'];
    thumbnail = json['thumbnail'];
    isCoverLocal = json['isCoverLocal'];
    description = json['description'];
    tags = json['tags'] == null ? [] : json['tags'].cast<String>();
    artistId = json["artistId"];
    isFileLocal = json['isFileLocal'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['lyrics'] = this.lyrics;
    data['stageName'] = this.stageName;
    data['filepath'] = this.filepath;
    data['cover'] = this.cover;
    data['thumb'] = this.thumb;
    data['thumbnail'] = this.thumbnail;
    data['isCoverLocal'] = this.isCoverLocal;
    data['description'] = this.description;
    data["artistId"] = this.artistId;
    data['isFileLocal'] = this.isFileLocal;
    return data;
  }
}
