import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/phoneWithCountry.dart';
import 'package:rally/components/textField.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/strings.dart';
import 'package:rally/spec/styles.dart';

Widget enrollAsArtistWidget({
  @required BuildContext? context,
  @required void Function()? onEnroll,
  @required TextEditingController? emailController,
  @required TextEditingController? phoneController,
  @required TextEditingController? stageNameController,
  @required TextEditingController? fNameController,
  @required TextEditingController? lNameController,
  @required FocusNode? stageNameFocusNode,
  @required FocusNode? emailFocusNode,
  @required FocusNode? phoneFocusNode,
  @required FocusNode? fNameFocusNode,
  @required FocusNode? lNameFocusNode,
  @required Key? key,
  @required void Function(Country country)? onCountry,
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
            Text("First Name", style: h5White),
            SizedBox(height: 10),
            textFormField(
              hintText: "First Name",
              controller: fNameController,
              focusNode: fNameFocusNode,
              validateMsg: REQUIREDFIELDMSG,
            ),
            SizedBox(height: 10),
            Text("Last Name", style: h5White),
            SizedBox(height: 10),
            textFormField(
              hintText: "Last Name",
              controller: lNameController,
              focusNode: lNameFocusNode,
              validateMsg: REQUIREDFIELDMSG,
            ),
            SizedBox(height: 10),
            Text("Stage Name", style: h5White),
            SizedBox(height: 10),
            textFormField(
              hintText: "Stage Name",
              controller: stageNameController,
              focusNode: stageNameFocusNode,
              validateMsg: REQUIREDFIELDMSG,
            ),
            SizedBox(height: 10),
            Text("Email", style: h5White),
            SizedBox(height: 10),
            textFormField(
              hintText: "Enter your email",
              controller: emailController,
              focusNode: emailFocusNode,
              validateMsg: REQUIREDFIELDMSG,
              enable: false,
            ),
            SizedBox(height: 10),
            Text("Phone", style: h5White),
            SizedBox(height: 10),
            phoneWithCountry(
              context: context,
              onCountry: (Country country) => onCountry!(country),
              phoneController: phoneController,
              phoneFocusNode: phoneFocusNode,
            ),
            SizedBox(height: 30),
            button(
              onPressed: onEnroll,
              text: "Enroll",
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
