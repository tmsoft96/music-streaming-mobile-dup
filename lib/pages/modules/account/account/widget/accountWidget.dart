import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/profilePicWithUploadButton.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/properties.dart';
import 'package:rally/spec/styles.dart';

Widget accountWidget({
  @required BuildContext? context,
  @required void Function()? onUpload,
  @required void Function()? onResetPassword,
  @required void Function()? onLogout,
  @required void Function()? onDeleteAccount,
}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(height: 20),
        profilePicWithUploadButton(
          context: context,
          onUpload: onUpload,
          profilePicture: '${userModel!.data!.user!.picture!}',
        ),
        SizedBox(height: 10),
        Text(
          "${userModel!.data!.user!.fname!} ${userModel!.data!.user!.lname!}",
          style: h3WhiteBold,
        ),
        SizedBox(height: 10),
        Text(
          "Last login: ${getReaderDate(
            userModel!.data!.user!.lastLogin!,
            showTimeOnly: true,
            showDateOnly: true,
          )}",
          style: h6White,
        ),
        SizedBox(height: 40),
        Container(
          color: PRIMARYCOLOR1,
          child: Column(
            children: [
              ListTile(
                leading: Icon(FeatherIcons.lock, color: BLACK),
                title: Text("Reset Password", style: h5WhiteBold),
                trailing: Icon(Icons.arrow_forward_ios, color: BLACK),
                onTap: onResetPassword,
              ),
              Divider(indent: 50),
              ListTile(
                leading: Icon(Icons.logout, color: BLACK),
                title: Text("Logout", style: h5WhiteBold),
                trailing: Icon(Icons.arrow_forward_ios, color: BLACK),
                onTap: onLogout,
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
        Image.asset(APPICON, width: 60),
        SizedBox(height: 10),
        Text("$VERSION", style: h6White),
        SizedBox(height: 30),
        Center(
          child: button(
            onPressed: onDeleteAccount,
            text: "Delete Account",
            textColor: BLACK,
            color: PRIMARYCOLOR1,
            context: context,
            divideWidth: .8,
            textStyle: h5BlackBold,
          ),
        ),
      ],
    ),
  );
}
