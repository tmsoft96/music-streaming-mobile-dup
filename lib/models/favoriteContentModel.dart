class FavoriteContentModel {
  List<String>? contentIdList;

  FavoriteContentModel({this.contentIdList});

  FavoriteContentModel.fromJson(List<dynamic>? json) {
    if (json != null) {
      contentIdList = json.cast<String>();
    }
  }

  List<String> toJson() {
   List<String> data = <String>[];
   data = this.contentIdList!;
   return data;
  }

  void addContent(String contentId) {
    contentIdList!.add(contentId);
  }
}
