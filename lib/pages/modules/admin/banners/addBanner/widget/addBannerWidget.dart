import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/textField.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/strings.dart';
import 'package:rally/spec/styles.dart';

Widget addBannerWidget({
  @required BuildContext? context,
  @required TextEditingController? titleController,
  @required FocusNode? titleFocusNode,
  @required String? bannerCover,
  @required bool? isLocalImage,
  @required void Function()? onUploadBannerCover,
  @required List<AllMusicData>? contentList,
  @required void Function(bool isEdit)? onUploadContent,
  @required void Function(int index)? onContent,
  @required void Function(int index)? onRemoveContent,
  @required void Function()? onPostBanner,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            "All banners created will be shown on the users' dashboard. This feature can be used to promote content.",
            style: h5WhiteBold,
          ),
          SizedBox(height: 20),
          Text("Title", style: h4White),
          SizedBox(height: 10),
          textFormField(
            hintText: "Enter title",
            controller: titleController,
            focusNode: titleFocusNode,
            validateMsg: REQUIREDFIELDMSG,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Upload cover", style: h5WhiteBold),
              if (bannerCover != "")
                button(
                  onPressed: onUploadBannerCover,
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
          if (bannerCover != null && bannerCover != "")
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: isLocalImage!
                  ? Image.file(
                      File(bannerCover),
                      height: 150,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    )
                  : cachedImage(
                      context: context,
                      image: bannerCover,
                      height: 150,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
            ),
          if (bannerCover == "") _button(onUploadBannerCover),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Attach content(s)", style: h5WhiteBold),
              if (contentList!.length > 0)
                button(
                  onPressed: () => onUploadContent!(true),
                  text: "Add",
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
                      leading: cachedImage(
                        context: context,
                        image: contentList[x].cover,
                        height: 50,
                        width: 50,
                      ),
                      title: Text(contentList[x].title!, style: h5WhiteBold),
                      subtitle: Text(
                        contentList[x].stageName ?? contentList[x].user!.name!,
                        style: h6White,
                      ),
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
          SizedBox(height: 20),
          button(
            onPressed: onPostBanner,
            text: "Post Banner",
            color: PRIMARYCOLOR,
            context: context,
          ),
          SizedBox(height: 20),
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
