import 'package:flutter/material.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allPlaylistsModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Dialog playlistReadMoreDialog(AllPlaylistsData data) {
  return Dialog(
    child: Container(
      padding: EdgeInsets.all(10),
      color: BLACK,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title", style: h5BlackBold),
            SizedBox(height: 10),
            Text(
              "${data.title!} - (${data.content!.length} songs)",
              style: h5Black,
            ),
            SizedBox(height: 20),
            Text("Description", style: h5BlackBold),
            SizedBox(height: 10),
            Text(
              "${data.description!}",
              style: h5Black,
            ),
            SizedBox(height: 20),
            Text("Created By", style: h5BlackBold),
            SizedBox(height: 10),
            Text(
              "${data.user!.stageName ?? data.user!.name}",
              style: h5Black,
            ),
            SizedBox(height: 20),
            Text("Release Date", style: h5BlackBold),
            SizedBox(height: 10),
            Text(
              "${getReaderDate(data.createdAt!)}",
              style: h5Black,
            ),
          ],
        ),
      ),
    ),
  );
}
