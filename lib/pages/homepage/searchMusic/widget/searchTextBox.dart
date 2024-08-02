import 'package:rally/components/textField.dart';
import 'package:rally/spec/colors.dart';
import 'package:flutter/material.dart';

Widget searchTextBox({
  @required void Function(String text)? onSearchChange,
  @required FocusNode? searchFocusNode,
  @required TextEditingController? searchController,
  @required void Function()? onClear,
}) {
  return Container(
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: BACKGROUND,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: WHITE.withOpacity(.3),
          blurRadius: 5, // soften the shadow
          spreadRadius: 0.1, //extend the shadow
          offset: Offset(
            0.0, // Move to right 10  horizontally
            2.0, // Move to bottom 10 Vertically
          ),
        )
      ],
    ),
    height: 50,
    child: textFormField(
      hintText: "Search",
      controller: searchController,
      focusNode: searchFocusNode,
      onTextChange: (String text) => onSearchChange!(text),
      borderRadius: 10,
      removeBorder: false,
      showBorderRound: true,
      prefixIcon:  Icons.search,
      icon: searchController!.text != "" ? Icons.close : null,
      onIconTap: onClear,
    ),
  );
}
