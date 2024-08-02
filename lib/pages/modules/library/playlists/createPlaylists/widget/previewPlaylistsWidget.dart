import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/models/myPlaylistsModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

import 'previewPlaylistPopup.dart';

Widget previewPlaylistsWidget({
  @required BuildContext? context,
  @required void Function()? onAddPlaylist,
  @required void Function(MyPlaylistsData data)? onPlaylist,
  @required MyPlaylistsModel? model,
  @required void Function(String action, MyPlaylistsData data)? onPopupAction,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text("Create new playlist", style: h5White),
          SizedBox(height: 10),
          ListTile(
            onTap: onAddPlaylist,
            leading: Container(
              height: 60,
              width: 60,
              color: PRIMARYCOLOR1,
              child: Icon(Icons.add, color: BLACK),
            ),
            title: Text("Tap to create a new playlist", style: h5White),
          ),
          SizedBox(height: 10),
          Divider(color: BLACK),
          SizedBox(height: 20),
          Text("Add to exiting playlist", style: h5White),
          SizedBox(height: 10),
          if (model!.data!.length == 0)
            emptyBox(
              context!,
              msg: "No Exiting playlist",
            ),
          for (var data in model.data!) ...[
            ListTile(
              onTap: () => onPlaylist!(data),
              leading: cachedImage(
                context: context,
                image: "${data.media!.thumb}",
                height: 60,
                width: 60,
              ),
              title: Text("${data.title}", style: h5White),
              subtitle: Text("${data.content!.length} songs", style: h6White),
              trailing: previewPlaylistPopup(
                onAction: (String action) => onPopupAction!(action, data),
              ),
            ),
            SizedBox(height: 10),
          ],
        ],
      ),
    ),
  );
}
