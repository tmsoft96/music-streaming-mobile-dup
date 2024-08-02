import 'package:rally/components/button.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/passwordField.dart';
import 'package:rally/components/textField.dart';
import 'package:rally/spec/strings.dart';
import 'package:rally/spec/styles.dart';

Widget loginWidget({
  @required TextEditingController? emailController,
  @required TextEditingController? passwordController,
  @required FocusNode? emailFocusNode,
  @required FocusNode? passwordFocusNode,
  @required void Function()? onForgetPassword,
  @required void Function()? onSignUp,
  @required void Function()? onLogin,
  @required BuildContext? context,
  @required Key? key,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: SingleChildScrollView(
      child: Form(
        key: key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Image.asset(LOGO, scale: 2),
            SizedBox(height: 10),
            Text("Login", style: h3White),
            SizedBox(height: 30),
            Text("Email", style: h5White),
            SizedBox(height: 10),
            textFormField(
              hintText: "Enter email",
              controller: emailController,
              focusNode: emailFocusNode,
              icon: Icons.email,
              validateMsg: REQUIREDFIELDMSG,
              inputType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            Text("Password", style: h5White),
            SizedBox(height: 10),
            PasswordField(
              hintText: "Enter password",
              controller: passwordController,
              focusNode: passwordFocusNode,
              validateMsg: REQUIREDFIELDMSG,
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: button(
                onPressed: onForgetPassword,
                text: "Forgot Password?",
                color: TRANSPARENT,
                textColor: PRIMARYCOLOR,
                textStyle: h5BlackBold,
                context: context,
                useWidth: false,
              ),
            ),
            SizedBox(height: 20),
            button(
              onPressed: onLogin,
              text: "LOGIN",
              color: PRIMARYCOLOR,
              context: context,
            ),
            SizedBox(height: 30),
            button(
              onPressed: onSignUp,
              text: "Don't have an account? Sign up",
              color: BACKGROUND,
              textColor: BLACK,
              textStyle: h4BlackBold,
              context: context,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}
