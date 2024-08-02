class RecentlyPlayedJointModel {
  List<RecentlyPlayedJointData>? data;

  RecentlyPlayedJointModel({this.data});

  RecentlyPlayedJointModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <RecentlyPlayedJointData>[];
      json['data'].forEach((v) {
        data!.add(new RecentlyPlayedJointData.fromJson(v));
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

class RecentlyPlayedJointData {
  String? id;
  String? cover;
  String? title;
  List<RecentlyPlayedContent>? content;
  String? artistName;
  String? description;
  String? createAt;
  String? contentType;

  RecentlyPlayedJointData({
    this.id,
    this.cover,
    this.title,
    this.content,
    this.artistName,
    this.createAt,
    this.description,
    this.contentType,
  });

  RecentlyPlayedJointData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cover = json['cover'];
    title = json['title'];
    artistName = json['artistName'] ?? "N/A";
    createAt = json['createAt'] ?? "N/A";
    description = json['description'] ?? "N/A";
    if (json['content'] != null) {
      content = <RecentlyPlayedContent>[];
      json['content'].forEach((v) {
        content!.add(new RecentlyPlayedContent.fromJson(v));
      });
    }
    contentType = id!.contains("banner")
        ? "banner"
        : id!.contains("playlist")
            ? "playlist"
            : "album";
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

    return data;
  }
}

class RecentlyPlayedContent {
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

  RecentlyPlayedContent(
      {this.id,
      this.title,
      this.lyrics,
      this.stageName,
      this.filepath,
      this.cover,
      this.thumbnail,
      this.isCoverLocal,
      this.artistId,
      this.description});

  RecentlyPlayedContent.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    title = json['title'];
    lyrics = json['lyrics'];
    stageName = json['stageName'];
    filepath = json['filepath'];
    cover = json['cover'];
    thumbnail = json['thumbnail'];
    isCoverLocal = json['isCoverLocal'];
    description = json['description'];
    artistId = json["artistId"];
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
    return data;
  }
}
