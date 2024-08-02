import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/textField.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/strings.dart';
import 'package:rally/spec/styles.dart';

Widget addRadioWidget({
  @required BuildContext? context,
  @required TextEditingController? titleController,
  @required TextEditingController? descriptionController,
  @required FocusNode? titleFocusNode,
  @required FocusNode? descriptionFocusNode,
  @required String? broadcastCover,
  @required bool? isLocalImage,
  @required void Function()? onUploadBroadcastCover,
  @required void Function()? onTime,
  @required void Function()? onDate,
  @required void Function()? onSubmit,
  @required void Function()? onPlayPreRecorded,
  @required void Function(String text)? onDescriptionTextChange,
  @required Key? key,
  @required int? descriptionLength,
  @required bool? isDescriptionFull,
  @required String? time,
  @required String? date,
  @required List<Map<String, dynamic>>? broadcastTypeList,
  @required void Function(int index)? onBroadcastType,
  @required TextEditingController? tagController,
  @required FocusNode? tagFocusNode,
  @required void Function(int index)? onTagDelete,
  @required void Function()? onTagAdd,
  @required int? tagLength,
  @required List<dynamic>? tagsList,
  @required bool? isTagFull,
  @required void Function(String text)? onTagTextChange,
  @required List<File>? contentList,
  @required void Function(bool isEdit)? onUploadContent,
  @required void Function(int index)? onRemoveContent,
  @required void Function(int index)? onContent,
  @required int? selectedBroadcastIndex,
  @required bool? isLocalContent,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Upload cover", style: h4WhiteBold),
                if (broadcastCover != "")
                  button(
                    onPressed: onUploadBroadcastCover,
                    text: "Upload",
                    color: PRIMARYCOLOR.withOpacity(.3),
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
            if (broadcastCover != null && broadcastCover != "")
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: isLocalImage!
                    ? Image.file(
                        File(broadcastCover),
                        height: 200,
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                      )
                    : cachedImage(
                        context: context,
                        image: broadcastCover,
                        height: 200,
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                      ),
              ),
            if (broadcastCover == "") _button(onUploadBroadcastCover),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Description", style: h5WhiteBold),
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
              showCounterText: false,
              validateMsg: REQUIREDFIELDMSG,
              onTextChange: (String text) => onDescriptionTextChange!(text),
              backgroundColor: isDescriptionFull! ? RED : PRIMARYCOLOR1,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tags", style: h5WhiteBold),
                Text("$tagLength / 5000 words", style: h5White),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "This helps in our search algorithm.\nSeparate each tag with \";\"",
              style: h5White,
            ),
            SizedBox(height: 10),
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isTagFull! ? RED : PRIMARYCOLOR1,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      for (int x = 0; x < tagsList!.length; ++x)
                        Chip(
                          label: Text("${tagsList[x]}"),
                          deleteIcon: Icon(
                            FeatherIcons.minusCircle,
                            color: RED,
                          ),
                          onDeleted: () => onTagDelete!(x),
                        ),
                    ],
                  ),
                  SizedBox(height: 10),
                  textFormField(
                    hintText: "Enter tag",
                    controller: tagController,
                    focusNode: tagFocusNode,
                    showBorderRound: false,
                    borderColor: BLACK,
                    removeBorder: false,
                    icon: Icons.add_circle,
                    iconColor: PRIMARYCOLOR,
                    onIconTap: onTagAdd,
                    validate: false,
                    onTextChange: (String text) => onTagTextChange!(text),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              minVerticalPadding: 20,
              tileColor: PRIMARYCOLOR1,
              leading: Icon(
                Icons.timer_outlined,
                size: 30,
                color: PRIMARYCOLOR,
              ),
              title: Text("Start Time", style: h6White),
              subtitle: time == "" || time == null
                  ? null
                  : Text(
                      time,
                      style: h3WhiteBold,
                    ),
              trailing: button(
                onPressed: onTime,
                text: "Select",
                color: TRANSPARENT,
                context: context,
                textColor: PRIMARYCOLOR,
                useWidth: false,
                padding: EdgeInsets.zero,
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              minVerticalPadding: 20,
              leading: Icon(
                FeatherIcons.calendar,
                size: 30,
                color: PRIMARYCOLOR,
              ),
              tileColor: PRIMARYCOLOR1,
              title: Text("Date", style: h6White),
              subtitle: date == "" || date == null
                  ? null
                  : Text(date, style: h3WhiteBold),
              trailing: button(
                onPressed: onDate,
                text: "Select",
                color: TRANSPARENT,
                context: context,
                textColor: PRIMARYCOLOR,
                useWidth: false,
                padding: EdgeInsets.zero,
              ),
            ),
            SizedBox(height: 10),
            Text("Broadcast Type", style: h5WhiteBold),
            SizedBox(height: 10),
            for (int x = 0; x < broadcastTypeList!.length; ++x) ...[
              CheckboxListTile(
                value: broadcastTypeList[x]["selected"],
                activeColor: PRIMARYCOLOR,
                onChanged: (bool? check) => onBroadcastType!(x),
                tileColor: PRIMARYCOLOR1,
                title: Text(
                  broadcastTypeList[x]["title"],
                  style: h5WhiteBold,
                ),
              ),
              Divider(),
            ],
            if (selectedBroadcastIndex == 0) ...[
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Upload pre-recorded content", style: h4WhiteBold),
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
                  color: BLACK,
                  padding: EdgeInsets.all(10),
                  child: isLocalContent!
                      ? Column(
                          children: [
                            for (int x = 0; x < contentList.length; ++x) ...[
                              ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 5),
                                onTap: () => onContent!(x),
                                tileColor: BLACK,
                                title: Text(
                                    "${contentList[x].path.split('/').last}"),
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
                        )
                      : ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          onTap: onPlayPreRecorded,
                          leading: Icon(Icons.music_note, color: PRIMARYCOLOR),
                          tileColor: BLACK,
                          title: Text("Recorded file"),
                          subtitle: Text("Tap to listen", style: h5PrimaryBold),
                        ),
                ),
              if (contentList.length == 0)
                _button(() => onUploadContent!(false)),
            ],
            SizedBox(height: 20),
            button(
              onPressed: onSubmit,
              text: "Submit",
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
