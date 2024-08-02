import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/services.dart';
import 'package:rally/pages/modules/account/enroll/widget/enrollAsArtistWidget.dart';
import 'package:rally/providers/getUserDetailsProvider.dart';
import 'package:rally/spec/colors.dart';

class EnrollAsArtist extends StatefulWidget {
  const EnrollAsArtist({Key? key}) : super(key: key);

  @override
  _EnrollAsArtistState createState() => _EnrollAsArtistState();
}

class _EnrollAsArtistState extends State<EnrollAsArtist> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = new TextEditingController(
    text: userModel!.data!.user!.email,
  );
  final _phoneController = new TextEditingController();
  final _stageNameController = new TextEditingController();
  final _fNameController = new TextEditingController();
  final _lNameController = new TextEditingController();

  bool _isLoading = false;
  // ignore: unused_field
  String _countryCode = "GH", _phoneCode = "233";

  FocusNode? _phoneFocusNode,
      _emailFocusNode,
      _fNameFocusNode,
      _lNameFocusNode,
      _stageNameFocusNode;
  @override
  void initState() {
    super.initState();
    _phoneFocusNode = new FocusNode();
    _emailFocusNode = new FocusNode();
    _stageNameFocusNode = new FocusNode();
    _fNameFocusNode = new FocusNode();
    _lNameFocusNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _phoneFocusNode!.dispose();
    _emailFocusNode!.dispose();
    _stageNameFocusNode!.dispose();
    _fNameFocusNode!.dispose();
    _lNameFocusNode!.dispose();
  }

  void _unfocusAllNode() {
    _phoneFocusNode!.unfocus();
    _emailFocusNode!.unfocus();
    _stageNameFocusNode!.unfocus();
    _fNameFocusNode!.unfocus();
    _lNameFocusNode!.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enroll as Artist")),
      body: Stack(
        children: [
          enrollAsArtistWidget(
            context: context,
            emailController: _emailController,
            emailFocusNode: _emailFocusNode,
            fNameController: _fNameController,
            fNameFocusNode: _fNameFocusNode,
            key: _formKey,
            lNameController: _lNameController,
            lNameFocusNode: _lNameFocusNode,
            onCountry: (Country country) => _onCountry(country),
            phoneController: _phoneController,
            phoneFocusNode: _phoneFocusNode,
            stageNameController: _stageNameController,
            stageNameFocusNode: _stageNameFocusNode,
            onEnroll: () => _onEnroll(),
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
    );
  }

  Future<void> _onEnroll() async {
    _unfocusAllNode();
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      String fullPhoneNumber;
      if (_phoneController.text.startsWith("0"))
        fullPhoneNumber =
            "$_phoneCode${_phoneController.text.substring(1, _phoneController.text.length)}";
      else
        fullPhoneNumber = "$_phoneCode${_phoneController.text}";

      Map<String, dynamic> httpResult = await httpChecker(
        httpRequesting: () => httpRequesting(
          endPoint: REGISTERARTIST_URL,
          method: HTTPMETHOD.POST,
          httpPostBody: {
            "firstName": _fNameController.text,
            "lastName": _lNameController.text,
            "stageName": _stageNameController.text,
            "email": _emailController.text,
            "phoneNumber": fullPhoneNumber,
          },
        ),
      );
      if (httpResult['ok']) {
        GetUserDetailsProvider provider = GetUserDetailsProvider();
        userModel = await provider.fetch(
          token: userModel!.data!.token,
          userId: userModel!.data!.user!.userid,
        );
        navigation(context: context, pageName: "homepage");
        setState(() => _isLoading = false);
        toastContainer(
          text: httpResult["data"]["msg"],
          backgroundColor: GREEN,
        );
      } else {
        setState(() => _isLoading = false);
        toastContainer(text: httpResult["data"]["msg"], backgroundColor: RED);
      }
    }
  }

  void _onCountry(Country country) {
    _countryCode = country.isoCode;
    _phoneCode = country.phoneCode;
  }
}
