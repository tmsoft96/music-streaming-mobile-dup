class PlayerModel {
  List<PlayerData>? data;

  PlayerModel({this.data});

  PlayerModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PlayerData>[];
      json['data'].forEach((v) {
        data!.add(new PlayerData.fromJson(v));
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

class PlayerData {
  String? id;
  String? title;
  String? lyrics;
  String? stageName;
  String? artistId;
  String? filepath;
  String? cover;
  String? thumb;
  String? thumbnail;
  bool? isCoverLocal;
  bool? isFileLocal;
  String? description;
  String? duration;
  String? tempDuration;
  List<String>? tags;
  bool? isPlaying;
  bool? isQueue;

  PlayerData({
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
    this.duration,
    this.isPlaying,
    this.tags,
    this.tempDuration,
    this.isQueue,
    this.isFileLocal,
    this.artistId,
  });

  PlayerData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    title = json['title'];
    lyrics = json['lyrics'];
    stageName = json['stageName'];
    filepath = json['filepath'];
    cover = json['cover'];
    thumb = json['thumb'] ?? json['cover'];
    thumbnail = json['thumbnail'] ?? "";
    isCoverLocal = json['isCoverLocal'];
    isFileLocal = json['isFileLocal'] ?? false;
    description = json['description'];
    tags = json['tags'] == null ? [] : json['tags'].cast<String>();
    isPlaying = false;
    duration = json['duration'] ?? "";
    tempDuration = json['tempDuration'] ?? "";
    isQueue = json["isQueue"] ?? false;
    artistId = json["artistId"] ?? "";
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
    data['isFileLocal'] = this.isFileLocal;
    data['description'] = this.description;
    data['tags'] = this.tags;
    data["artistId"] = this.artistId;
    return data;
  }
}
