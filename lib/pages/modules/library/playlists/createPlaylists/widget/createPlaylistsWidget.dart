import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/textField.dart';
import 'package:rally/models/myPlaylistsModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/strings.dart';
import 'package:rally/spec/styles.dart';

Widget createPlaylistsWidget({
  @required BuildContext? context,
  @required TextEditingController? titleController,
  @required TextEditingController? genreController,
  @required TextEditingController? descriptionController,
  @required TextEditingController? permissionController,
  @required FocusNode? titleFocusNode,
  @required FocusNode? descriptionFocusNode,
  @required String? cover,
  @required bool? isLocalImage,
  @required void Function()? onUploadBannerCover,
  @required void Function()? onGenre,
  @required void Function()? onPermission,
  @required void Function()? onSave,
  @required void Function()? onMyPlaylists,
  @required Key? key,
  @required int? descriptionLength,
  @required void Function(String text)? onDescriptionTextChange,
  @required bool? isDescriptionFull,
  @required MyPlaylistsModel? model,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: SingleChildScrollView(
      child: Form(
        key: key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            if (model != null && model.data!.length > 0) ...[
              button(
                onPressed: onMyPlaylists,
                text: "View My Playlists",
                color: PRIMARYCOLOR,
                colorFill: false,
                showBorder: true,
                context: context,
                useWidth: false,
                textColor: PRIMARYCOLOR,
                textStyle: h5BlackBold,
                buttonRadius: 10,
                height: 40,
              ),
              SizedBox(height: 30),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Upload cover", style: h5WhiteBold),
                if (cover != "")
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
            if (cover != null && cover != "")
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: isLocalImage!
                    ? Image.file(
                        File(cover),
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      )
                    : cachedImage(
                        context: context,
                        image: cover,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
              ),
            if (cover == "") _button(onUploadBannerCover),
            SizedBox(height: 10),
            Text("Title", style: h4White),
            SizedBox(height: 10),
            textFormField(
              hintText: "Enter title",
              controller: titleController,
              focusNode: titleFocusNode,
              validateMsg: REQUIREDFIELDMSG,
            ),
            SizedBox(height: 10),
            Text("Genre", style: h4White),
            SizedBox(height: 10),
            GestureDetector(
              onTap: onGenre,
              child: textFormField(
                hintText: "Select genre",
                controller: genreController,
                focusNode: null,
                validateMsg: REQUIREDFIELDMSG,
                enable: false,
                icon: Icons.arrow_drop_down,
              ),
            ),
            SizedBox(height: 10),
            Text("Permissions", style: h4White),
            SizedBox(height: 10),
            GestureDetector(
              onTap: onPermission,
              child: textFormField(
                hintText: "Select permission",
                controller: permissionController,
                focusNode: null,
                validateMsg: REQUIREDFIELDMSG,
                enable: false,
                icon: Icons.arrow_drop_down,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Description (Optional)", style: h6WhiteBold),
                Text("$descriptionLength / 5000 words", style: h5White),
              ],
            ),
            SizedBox(height: 10),
            textFormField(
              hintText: "Enter description",
              controller: descriptionController,
              focusNode: descriptionFocusNode,
              minLine: 5,
              maxLine: null,
              // maxLength: 5000,
              validate: false,
              showCounterText: false,
              validateMsg: REQUIREDFIELDMSG,
              onTextChange: (String text) => onDescriptionTextChange!(text),
              backgroundColor: isDescriptionFull! ? RED : PRIMARYCOLOR1,
            ),
            SizedBox(height: 20),
            button(
              onPressed: onSave,
              text: "SAVE",
              color: PRIMARYCOLOR,
              context: context,
            ),
            SizedBox(height: 20),
          ],
        ),
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
