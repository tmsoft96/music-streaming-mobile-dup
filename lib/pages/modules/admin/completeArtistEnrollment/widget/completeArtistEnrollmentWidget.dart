import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/components/passwordField.dart';
import 'package:rally/components/phoneWithCountry.dart';
import 'package:rally/components/textField.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/strings.dart';
import 'package:rally/spec/styles.dart';

Widget completeArtistEnrollmentWidget({
  @required BuildContext? context,
  @required void Function()? onSumbit,
  @required Function()? onDOB,
  @required TextEditingController? emailController,
  @required TextEditingController? phoneController,
  @required TextEditingController? stageNameController,
  @required TextEditingController? fNameController,
  @required TextEditingController? lNameController,
  @required TextEditingController? genderController,
  @required TextEditingController? bioController,
  @required TextEditingController? dobController,
  @required TextEditingController? passwordController,
  @required TextEditingController? comfPassController,
  @required FocusNode? passwordFocusNode,
  @required FocusNode? comfPassfocusNode,
  @required FocusNode? stageNameFocusNode,
  @required FocusNode? emailFocusNode,
  @required FocusNode? phoneFocusNode,
  @required FocusNode? fNameFocusNode,
  @required FocusNode? lNameFocusNode,
  @required FocusNode? bioFocusNode,
  @required Key? key,
  @required void Function(Country country)? onCountry,
  @required Function()? onGender,
  @required String? profilePic,
  @required bool? isLocalUpload,
  @required void Function()? onUploadProfilePicture,
  @required bool? isEdit,
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
            Text("Profile Picture", style: h5WhiteBold),
            SizedBox(height: 10),
            Center(
              child: circular(
                child: isLocalUpload!
                    ? Image.file(
                        File(profilePic!),
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,
                      )
                    : cachedImage(
                        context: context,
                        image: profilePic,
                        height: 160,
                        width: 160,
                        placeholder: DEFAULTPROFILEPICOFFLINE,
                        fit: BoxFit.cover,
                      ),
                size: 160,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: button(
                onPressed: onUploadProfilePicture,
                text: 'Upload',
                color: BLACK,
                context: context,
                useWidth: false,
                textColor: WHITE,
              ),
            ),
            SizedBox(height: 10),
            Text("First Name", style: h5WhiteBold),
            SizedBox(height: 10),
            textFormField(
              hintText: "First Name",
              controller: fNameController,
              focusNode: fNameFocusNode,
              validateMsg: REQUIREDFIELDMSG,
            ),
            SizedBox(height: 10),
            Text("Last Name", style: h5WhiteBold),
            SizedBox(height: 10),
            textFormField(
              hintText: "Last Name",
              controller: lNameController,
              focusNode: lNameFocusNode,
              validateMsg: REQUIREDFIELDMSG,
            ),
            SizedBox(height: 10),
            Text("Stage Name", style: h5WhiteBold),
            SizedBox(height: 10),
            textFormField(
              hintText: "Stage Name",
              controller: stageNameController,
              focusNode: stageNameFocusNode,
              validateMsg: REQUIREDFIELDMSG,
            ),
            SizedBox(height: 10),
            Text("Email", style: h5WhiteBold),
            SizedBox(height: 10),
            textFormField(
                hintText: "Enter your email",
                controller: emailController,
                focusNode: emailFocusNode,
                validateMsg: REQUIREDFIELDMSG,
                enable: !isEdit!),
            SizedBox(height: 10),
            Text("Phone", style: h5WhiteBold),
            SizedBox(height: 10),
            phoneWithCountry(
              context: context,
              onCountry: (Country country) => onCountry!(country),
              phoneController: phoneController,
              phoneFocusNode: phoneFocusNode,
            ),
            SizedBox(height: 10),
            Text("Gender", style: h5WhiteBold),
            SizedBox(height: 10),
            GestureDetector(
              onTap: onGender,
              child: textFormField(
                hintText: "Select gender",
                controller: genderController,
                focusNode: null,
                enable: false,
                icon: Icons.arrow_drop_down,
                validateMsg: REQUIREDFIELDMSG,
              ),
            ),
            SizedBox(height: 10),
            Text("Date of Birth", style: h5WhiteBold),
            SizedBox(height: 10),
            GestureDetector(
              onTap: onDOB,
              child: textFormField(
                hintText: "Select date of birth",
                controller: dobController,
                focusNode: null,
                enable: false,
                icon: Icons.arrow_drop_down,
                validateMsg: REQUIREDFIELDMSG,
              ),
            ),
            SizedBox(height: 10),
            Text("Bio (Optional)", style: h5WhiteBold),
            SizedBox(height: 10),
            textFormField(
              hintText: "Enter Bio",
              controller: bioController,
              focusNode: bioFocusNode,
              validate: false,
              maxLine: null,
              minLine: 4,
            ),
            SizedBox(height: 10),
            if (!isEdit) ...[
              Text("Password", style: h5WhiteBold),
              SizedBox(height: 10),
              PasswordField(
                hintText: "Your Password",
                controller: passwordController,
                validateMsg: "Passwords do not match",
                focusNode: passwordFocusNode,
              ),
              SizedBox(height: 20),
              Text("Confirm Password", style: h5WhiteBold),
              SizedBox(height: 10),
              PasswordField(
                hintText: "Confirm Password",
                controller: comfPassController,
                validateMsg: "Passwords do not match",
                focusNode: comfPassfocusNode,
              ),
            ],
            SizedBox(height: 30),
            button(
              onPressed: onSumbit,
              text: "SUMBIT PROFILE",
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
