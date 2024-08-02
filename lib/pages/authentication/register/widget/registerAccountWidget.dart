import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/passwordField.dart';
import 'package:rally/components/textField.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/strings.dart';
import 'package:rally/spec/styles.dart';

Widget registerAccountWidget({
  @required TextEditingController? emailController,
  @required TextEditingController? passwordController,
  @required TextEditingController? comfPassController,
  required TextEditingController? fNameController,
  required TextEditingController? lNameController,
  @required FocusNode? passwordFocusNode,
  @required FocusNode? emailFocusNode,
  @required FocusNode? comfPassfocusNode,
  @required FocusNode? fNameFocusNode,
  @required FocusNode? lNameFocusNode,
  @required Key? key,
  @required BuildContext? context,
  @required void Function()? onCreateAccount,
  @required bool? signInAlready,
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
            Text("Account Details", style: h2WhiteBold),
            SizedBox(height: 20),
            Text("First Name", style: h5WhiteBold),
            SizedBox(height: 10),
            textFormField(
              hintText: "First Name",
              controller: fNameController,
              focusNode: fNameFocusNode,
              validateMsg: REQUIREDFIELDMSG,
            ),
            SizedBox(height: 20),
            Text("Last Name", style: h5WhiteBold),
            SizedBox(height: 10),
            textFormField(
              hintText: "Last Name",
              controller: lNameController,
              focusNode: lNameFocusNode,
              validateMsg: REQUIREDFIELDMSG,
            ),
            SizedBox(height: 20),
            Text("Email", style: h5WhiteBold),
            SizedBox(height: 10),
            textFormField(
              hintText: "Enter your email",
              controller: emailController,
              focusNode: emailFocusNode,
              validateMsg: REQUIREDFIELDMSG,
              enable: !signInAlready!,
            ),
            if (!signInAlready) ...[
              SizedBox(height: 20),
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
              onPressed: onCreateAccount,
              text: 'CREATE ACCOUNT',
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
