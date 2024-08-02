import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:rally/spec/strings.dart';
import 'package:rally/spec/styles.dart';

import 'textField.dart';

Widget phoneWithCountry({
  @required TextEditingController? phoneController,
  @required FocusNode? phoneFocusNode,
  @required void Function(Country country)? onCountry,
  @required BuildContext? context,
  bool enable = true,
}) {
  return Row(
    children: [
      CountryPickerDropdown(
        initialValue: 'GH',
        itemBuilder: _buildDropdownItem,
        priorityList: [
          CountryPickerUtils.getCountryByIsoCode('GB'),
          CountryPickerUtils.getCountryByIsoCode('CN'),
        ],
        sortComparator: (Country a, Country b) =>
            a.isoCode.compareTo(b.isoCode),
        onValuePicked: (Country country) => onCountry!(country),
      ),
      textFormField(
        width: MediaQuery.of(context!).size.width * .45,
        hintText: "Enter phone number",
        controller: phoneController!,
        focusNode: phoneFocusNode!,
        inputType: TextInputType.phone,
        validateMsg: REQUIREDFIELDMSG,
        enable: enable,
      ),
    ],
  );
}

Widget _buildDropdownItem(Country country) => Container(
      child: Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(
            width: 8.0,
          ),
          Text("+${country.phoneCode}(${country.isoCode})", style: h6White),
        ],
      ),
    );
