import 'package:flutter/material.dart';
import 'package:rally/components/contentDisplayFull.dart';
import 'package:rally/models/allMusicModel.dart';

Widget searchMusicTextWidget({
  @required BuildContext? context,
  @required AllMusicModel? model,
  @required String? searchText,
  @required void Function(AllMusicData data)? onMusic,
  @required void Function(AllMusicData data)? onMusicMore,
  @required void Function(AllMusicData data)? onMusicPlay,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 10),
      for (var data in model!.data!)
        if (data.title!.toLowerCase().contains(searchText!.toLowerCase()) ||
            data.stageName!
                .toLowerCase()
                .contains(searchText.toLowerCase())) ...[
          contentDisplayFull(
            context: context,
            image: data.media!.thumb,
            streamNumber: data.streams!.length,
            title: data.title,
            artistName: data.stageName,
            onContent: () => onMusic!(data),
            onContentMore: () => onMusicMore!(data),
            onContentPlay: () => onMusicPlay!(data),
          ),
        ] else ...[
          for (var tags in data.tags!)
            if (tags.toLowerCase().contains(searchText.toLowerCase())) ...[
              contentDisplayFull(
                context: context,
                image: data.media!.thumb,
                streamNumber: data.streams!.length,
                title: data.title,
                artistName: data.stageName,
                onContent: () => onMusic!(data),
                onContentMore: () => onMusicMore!(data),
                onContentPlay: () => onMusicPlay!(data),
              )
            ],
        ],
      SizedBox(height: 10),
    ],
  );
}
