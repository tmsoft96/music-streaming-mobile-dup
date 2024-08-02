import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/spec/arrays.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/properties.dart';
import 'package:rally/spec/styles.dart';

import 'introduceFriendWidget.dart';

Widget othersWidget({
  @required BuildContext? context,
  @required void Function()? onEditProfile,
  @required void Function()? onAccount,
  @required void Function()? onOurServices,
  @required void Function()? onEnroll,
  @required void Function()? onLegal,
  @required void Function()? onAboutUs,
  @required void Function()? onContactUs,
  @required void Function()? onInviteFriend,
}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(height: 5),
        ListTile(
          tileColor: PRIMARYCOLOR1,
          minVerticalPadding: 20,
          leading: circular(
            child: cachedImage(
              context: context,
              image: "${userModel!.data!.user!.picture!}",
              height: 60,
              width: 60,
              placeholder: DEFAULTPROFILEPICOFFLINE,
            ),
            size: 60,
          ),
          title: Text(
            "${userModel!.data!.user!.fname!} ${userModel!.data!.user!.lname!}",
            style: h4WhiteBold,
          ),
          subtitle: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              "${userModel!.data!.user!.email!}",
              style: h6White,
            ),
          ),
          trailing: IconButton(
            onPressed: onEditProfile,
            icon: Icon(Icons.edit),
            color: BLACK,
          ),
        ),
        SizedBox(height: 20),
        Container(
          color: PRIMARYCOLOR1,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.help, color: BLACK),
                title: Text("Our Services", style: h5WhiteBold),
                trailing: Icon(Icons.arrow_forward_ios, color: BLACK),
                onTap: onOurServices,
              ),
              Divider(indent: 50),
              if (userModel!.data!.user!.role!.toLowerCase() ==
                  userTypeList[0]) ...[
                ListTile(
                  leading: Icon(FeatherIcons.users, color: BLACK),
                  title: Text("Enroll as an Artist", style: h5WhiteBold),
                  trailing: Icon(Icons.arrow_forward_ios, color: BLACK),
                  onTap: onEnroll,
                ),
                Divider(indent: 50),
              ],
              ListTile(
                leading: Icon(FeatherIcons.settings, color: BLACK),
                title: Text("Settings", style: h5WhiteBold),
                trailing: Icon(Icons.arrow_forward_ios, color: BLACK),
                onTap: onAccount,
              ),
              Divider(indent: 50),
              ListTile(
                leading: Icon(FeatherIcons.fileText, color: BLACK),
                title: Text("Legal", style: h5WhiteBold),
                trailing: Icon(Icons.arrow_forward_ios, color: BLACK),
                onTap: onLegal,
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          color: PRIMARYCOLOR1,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.info, color: BLACK),
                title: Text("About us", style: h5WhiteBold),
                trailing: Icon(Icons.arrow_forward_ios, color: BLACK),
                onTap: onAboutUs,
              ),
              Divider(indent: 50),
              ListTile(
                leading: Icon(Icons.phone_android, color: BLACK),
                title: Text("Contact us", style: h5WhiteBold),
                trailing: Icon(Icons.arrow_forward_ios, color: BLACK),
                onTap: onContactUs,
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        introduceFriendWidget(
          context: context,
          onInvite: onInviteFriend,
        ),
        SizedBox(height: 10),
        Text(VERSION, style: h6White),
        SizedBox(height: 50),
      ],
    ),
  );
}
