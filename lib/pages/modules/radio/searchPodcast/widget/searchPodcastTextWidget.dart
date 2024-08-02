import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget searchPodcastTextWidget({
  @required BuildContext? context,
  @required AllPodcastModel? model,
  @required String? searchText,
  @required void Function(AllRadioData data)? onPodcast,
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
          ListTile(
            onTap: () => onPodcast!(data),
            leading: Icon(FeatherIcons.radio, color: BLACK),
            title: Text("${data.title}", style: h6White),
            subtitle: Text("${data.stageName}", style: h6White),
          ),
          Divider(color: WHITE, indent: 10),
        ] else ...[
          for (var tags in data.tags!)
            if (tags.toLowerCase().contains(searchText.toLowerCase())) ...[
              ListTile(
                onTap: () => onPodcast!(data),
                leading: Icon(FeatherIcons.radio, color: BLACK),
                title: Text("${data.title}", style: h6White),
                subtitle: Text("${data.stageName}", style: h6White),
              ),
              Divider(color: WHITE, indent: 10),
            ],
        ],
      SizedBox(height: 10),
    ],
  );
}
