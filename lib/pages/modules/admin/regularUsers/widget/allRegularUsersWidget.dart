import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/textField.dart';
import 'package:rally/models/allRegularUserModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget allRegularUsersWidget({
  @required BuildContext? context,
  @required FocusNode? searchFocusNode,
  @required void Function(String text)? onSearch,
  @required void Function(Data data)? onUser,
  @required AllRegularUserModel? model,
  @required String? searchText,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        textFormField(
          hintText: "Search by name or phone",
          controller: null,
          focusNode: searchFocusNode,
          removeBorder: true,
          prefixIcon: Icons.search,
          prefixIconColor: ASHDEEP,
          onTextChange: (String text) => onSearch!(text),
        ),
        SizedBox(height: 10),
        if (model!.data!.length == 0)
          emptyBox(context!, msg: "No data available"),
        if (model.data!.length > 0) ...[
          for (int x = 0; x < model.data!.length; ++x) ...[
            if (searchText != "" &&
                (model.data![x].name!
                        .toLowerCase()
                        .contains(searchText!.toLowerCase()) ||
                    (model.data![x].phone != null &&
                        model.data![x].phone!
                            .toLowerCase()
                            .contains(searchText.toLowerCase()))))
              _layout(
                data: model.data![x],
                onArtist: (Data data) => onUser!(data),
                context: context,
              ),
            if (searchText == "")
              _layout(
                data: model.data![x],
                onArtist: (Data data) => onUser!(data),
                context: context,
              ),
            SizedBox(height: 10),
          ],
          SizedBox(height: 70),
        ],
      ],
    ),
  );
}

Widget _layout({
  @required Data? data,
  @required void Function(Data data)? onArtist,
  @required BuildContext? context,
}) {
  return ListTile(
    onTap: () => onArtist!(data!),
    tileColor: PRIMARYCOLOR1,
    leading: circular(
      child: cachedImage(
        context: context,
        image: "${data!.picture}",
        height: 60,
        width: 60,
        placeholder: DEFAULTPROFILEPICOFFLINE,
      ),
      size: 60,
    ),
    title: Text("${data.name}", style: h4WhiteBold),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${data.email}", style: h6White),
        Text("${data.phone ?? 'N/A'}", style: h6White),
        Align(
          alignment: Alignment.bottomRight,
          child: Text("More", style: h5Red),
        ),
      ],
    ),
  );
}
