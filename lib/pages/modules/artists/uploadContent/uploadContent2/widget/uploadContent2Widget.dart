import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget uploadContent2Widget({
  @required BuildContext? context,
  @required void Function(bool isEdit)? onUploadContent,
  @required void Function()? onUploadContentCover,
  @required void Function()? onPlayAll,
  @required void Function(int index)? onRemoveContent,
  @required void Function(int index)? onContent,
  @required void Function(int index)? onEditName,
  @required Map<String, dynamic>? meta,
  @required List<File>? contentList,
  @required List<String>? contentNameList,
  @required String? contentCover,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (meta!["contentType"] == 0)
                Text("Upload Single (Audio only)", style: h4WhiteBold),
              if (meta["contentType"] == 1)
                Container(
                  width: MediaQuery.of(context!).size.width - 130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Upload Album or EP", style: h4WhiteBold),
                      SizedBox(height: 2),
                      Text(
                        "Confirm file title before continuing",
                        style: h6PrimaryBold,
                      ),
                    ],
                  ),
                ),
              if (contentList!.length > 0)
                button(
                  onPressed: () => onUploadContent!(true),
                  text: "Upload",
                  color: PRIMARYCOLOR.withOpacity(.6),
                  context: context,
                  useWidth: false,
                  textColor: BLACK,
                  textStyle: h5BlackBold,
                  buttonRadius: 10,
                  height: 40,
                ),
            ],
          ),
          SizedBox(height: 10),
          if (contentList.length > 0)
            Container(
              color: PRIMARYCOLOR1,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  for (int x = 0; x < contentList.length; ++x) ...[
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 5),
                      onTap: () => onContent!(x),
                      tileColor: PRIMARYCOLOR1,
                      title: Text("${contentNameList![x]}", style: h5White),
                      subtitle: meta["contentType"] == 1
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                button(
                                  onPressed: () => onEditName!(x),
                                  text: "Change Name",
                                  color: GREEN.withOpacity(.7),
                                  context: context,
                                  useWidth: false,
                                  height: 25,
                                  textStyle: h6BlackBold,
                                ),
                              ],
                            )
                          : null,
                      trailing: IconButton(
                        color: RED,
                        iconSize: 30,
                        icon: Icon(Icons.delete),
                        onPressed: () => onRemoveContent!(x),
                      ),
                    ),
                    Divider(),
                  ],
                ],
              ),
            ),
          if (contentList.length == 0) _button(() => onUploadContent!(false)),
          // SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Upload cover", style: h4WhiteBold),
            subtitle: Text("Max. Size: 5000 X 5000px", style: h5Red),
            trailing: contentCover != ""
                ? button(
                    onPressed: onUploadContentCover,
                    text: "Upload",
                    color: PRIMARYCOLOR.withOpacity(.6),
                    context: context,
                    useWidth: false,
                    textColor: BLACK,
                    textStyle: h5BlackBold,
                    buttonRadius: 10,
                    height: 40,
                  )
                : null,
          ),
          // SizedBox(height: 10),
          if (contentCover! != "")
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(contentCover),
                width: 100,
                height: 100,
              ),
            ),
          if (contentCover == "") _button(onUploadContentCover),
          SizedBox(height: 30),
          if (contentList.length > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Preview", style: h4WhiteBold),
                if (meta["contentType"] == 1)
                  button(
                    onPressed: onPlayAll,
                    text: "Play All",
                    color: PRIMARYCOLOR.withOpacity(.6),
                    context: context,
                    useWidth: false,
                    textColor: BLACK,
                    textStyle: h5BlackBold,
                    buttonRadius: 10,
                    height: 40,
                  ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: PRIMARYCOLOR1,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  for (int x = 0; x < contentList.length; ++x) ...[
                    GestureDetector(
                      onTap: () => onContent!(x),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: contentCover == ""
                                ? Image.asset(
                                    IMAGELOADINGERROROFFLINE,
                                    width: 70,
                                    height: 70,
                                  )
                                : Image.file(
                                    File(contentCover),
                                    width: 100,
                                    height: 100,
                                  ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "${contentNameList![x]}",
                              style: h5WhiteBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

Widget _button(void Function()? onAdd) {
  return GestureDetector(
    onTap: onAdd,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: PRIMARYCOLOR.withOpacity(.6),
      ),
      width: 100,
      height: 100,
      child: Icon(Icons.add, size: 50, color: BLACK),
    ),
  );
}
