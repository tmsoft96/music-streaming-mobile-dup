import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/coolAlertDialog.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpFileUploader.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/services.dart';
import 'package:rally/models/allArtistsModel.dart';
import 'package:rally/providers/getUserDetailsProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/theme.dart';
import 'package:rally/utils/captureImage/captureImage.dart';

import 'widget/completeArtistEnrollmentWidget.dart';

class CompleteArtistEnrollment extends StatefulWidget {
  final AllArtistData? allArtistData;
  final bool? isEdit;

  CompleteArtistEnrollment({
    this.allArtistData,
    this.isEdit = false,
  });

  @override
  _CompleteArtistEnrollmentState createState() =>
      _CompleteArtistEnrollmentState();
}

class _CompleteArtistEnrollmentState extends State<CompleteArtistEnrollment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = new TextEditingController();
  final _phoneController = new TextEditingController();
  final _stageNameController = new TextEditingController();
  final _fNameController = new TextEditingController();
  final _lNameController = new TextEditingController();
  final _bioController = new TextEditingController();
  final _genderController = new TextEditingController();
  final _dobController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _comfPassController = new TextEditingController();

  bool _isLoading = false, _isLocalUpload = false;
  String _countryCode = "GH", _phoneCode = "233";

  FocusNode? _phoneFocusNode,
      _emailFocusNode,
      _fNameFocusNode,
      _lNameFocusNode,
      _stageNameFocusNode,
      _bioFocusNode,
      _passwordFocusNode,
      _comfPassfocusNode;

  String _profilePic = "";

  @override
  void initState() {
    super.initState();
    _phoneFocusNode = new FocusNode();
    _emailFocusNode = new FocusNode();
    _stageNameFocusNode = new FocusNode();
    _fNameFocusNode = new FocusNode();
    _lNameFocusNode = new FocusNode();
    _bioFocusNode = new FocusNode();
    _passwordFocusNode = new FocusNode();
    _comfPassfocusNode = new FocusNode();

    // loading user data for edit
    _onLoadUserData();
  }

  @override
  void dispose() {
    super.dispose();
    _phoneFocusNode!.dispose();
    _emailFocusNode!.dispose();
    _stageNameFocusNode!.dispose();
    _fNameFocusNode!.dispose();
    _lNameFocusNode!.dispose();
    _bioFocusNode!.dispose();
    _passwordFocusNode!.dispose();
    _comfPassfocusNode!.dispose();
  }

  void _unfocusAllNode() {
    _phoneFocusNode!.unfocus();
    _emailFocusNode!.unfocus();
    _stageNameFocusNode!.unfocus();
    _fNameFocusNode!.unfocus();
    _lNameFocusNode!.unfocus();
    _bioFocusNode!.unfocus();
    _passwordFocusNode!.unfocus();
    _comfPassfocusNode!.unfocus();
  }

  void _onLoadUserData() {
    if (widget.allArtistData != null && widget.isEdit!) {
      _profilePic = widget.allArtistData!.picture ?? "";
      _emailController.text = widget.allArtistData!.email!;
      _stageNameController.text = widget.allArtistData!.stageName ?? "";
      _fNameController.text = widget.allArtistData!.fname!;
      _lNameController.text = widget.allArtistData!.lname!;
      _bioController.text = widget.allArtistData!.bio ?? "";
      _genderController.text = widget.allArtistData!.gender ?? "";
      _dobController.text = widget.allArtistData!.dob ?? "";
      String phone = widget.allArtistData!.phone ?? "";
      if (!phone.startsWith("0")) {
        _countryCode = widget.allArtistData!.country ?? "";
        _phoneCode = phone.substring(0, 3);
        _phoneController.text = phone.substring(3);
      } else {
        _phoneController.text = phone;
      }
    } else if (widget.isEdit!) {
      final user = userModel!.data!.user;
      _profilePic = user!.picture ?? "";
      _emailController.text = user.email!;
      _stageNameController.text = user.stageName ?? "";
      _fNameController.text = user.fname!;
      _lNameController.text = user.lname!;
      _bioController.text = user.bio ?? "";
      _genderController.text = user.gender ?? "";
      _dobController.text = user.dob ?? "";
      String phone = user.phone ?? "";
      if (!phone.startsWith("0")) {
        _countryCode = user.country ?? "";
        _phoneCode = phone.substring(0, 3);
        _phoneController.text = phone.substring(3);
      } else {
        _phoneController.text = phone;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Artist Profile")),
      body: Stack(
        children: [
          completeArtistEnrollmentWidget(
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
            onSumbit: () => _onConfimDialog(),
            onGender: () => _onGender(),
            bioController: _bioController,
            bioFocusNode: _bioFocusNode,
            genderController: _genderController,
            isLocalUpload: _isLocalUpload,
            onUploadProfilePicture: () => _onUploadProfilePicture(),
            profilePic: _profilePic,
            dobController: _dobController,
            onDOB: () => _onDOB(),
            passwordController: _passwordController,
            comfPassController: _comfPassController,
            passwordFocusNode: _passwordFocusNode,
            comfPassfocusNode: _comfPassfocusNode,
            isEdit: widget.allArtistData != null || widget.isEdit!,
          ),
          if (_isLoading)
            customLoadingPage(onClose: () {
              setState(() {
                _isLoading = false;
              });
            }),
        ],
      ),
    );
  }

  void _onConfimDialog() {
    _unfocusAllNode();

    if (_profilePic == "") {
      toastContainer(
        text: "Upload profile picture to continue",
        backgroundColor: RED,
      );
      return;
    }

    coolAlertDialog(
      context: context,
      onConfirmBtnTap: () => _onUploadProfile(),
      type: CoolAlertType.warning,
      text: "Confirm profile before submit",
      confirmBtnText: "Submit",
    );
  }

  Future<void> _onUploadProfile() async {
    navigation(context: context, pageName: "back");
    _unfocusAllNode();

    if (!_formKey.currentState!.validate()) {
      toastContainer(
        text: "Attend to all required fields",
        backgroundColor: RED,
      );
      return;
    }

    if (_passwordController.text != _comfPassController.text) {
      toastContainer(text: "Password not match", backgroundColor: RED);
      return;
    }

    setState(() => _isLoading = true);
    print(widget.allArtistData != null &&
        _profilePic != widget.allArtistData!.picture);
    if (_profilePic != "null" &&
        _profilePic != "" &&
        ((widget.allArtistData != null &&
                widget.isEdit! &&
                _profilePic != widget.allArtistData!.picture) ||
            (widget.allArtistData == null &&
                widget.isEdit! &&
                _profilePic != userModel!.data!.user!.picture))) {
      List<String> pathList = [_profilePic];
      await httpFileUploader(
        endpoint: PICTUREUPLOAD_URL,
        imageList: pathList,
        onFunction: () => _onSumbit(),
      );
    } else {
      allFileUrl.clear();
      _onSumbit();
    }
  }

  Future<void> _onSumbit() async {
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
          endPoint: widget.allArtistData != null && !widget.isEdit!
              ? ALLARTISTS_URL
              : UPDATEARTISTPROFILE_URL,
          method: HTTPMETHOD.POST,
          httpPostBody: widget.allArtistData != null && !widget.isEdit!
              ? {
                  "firstName": _fNameController.text,
                  "lastName": _lNameController.text,
                  "middleName": "",
                  "phoneNumber": fullPhoneNumber,
                  "email": _emailController.text,
                  "stageName": _stageNameController.text,
                  "country": _countryCode,
                  "gender": _genderController.text[0].toUpperCase(),
                  "bio": _bioController.text,
                  "dob": _dobController.text,
                  "createuser": userModel!.data!.user!.userid,
                  "verified": "0",
                  "emailVerified": "0",
                  "filepath": allFileUrl[0],
                  "password": _passwordController.text,
                  "password_confirmation": _comfPassController.text,
                  "genre": json.encode(["0"]),
                }
              : {
                  "userid": widget.allArtistData != null
                      ? widget.allArtistData!.userid
                      : userModel!.data!.user!.userid,
                  "firstName": _fNameController.text,
                  "lastName": _lNameController.text,
                  "middleName": widget.isEdit!
                      ? userModel!.data!.user!.mname ?? ""
                      : widget.allArtistData!.mname,
                  "phoneNumber": fullPhoneNumber,
                  "stageName": _stageNameController.text,
                  "country": _countryCode,
                  "gender": _genderController.text[0].toUpperCase(),
                  "bio": _bioController.text,
                  "dob": _dobController.text,
                  "modifyuser": userModel!.data!.user!.userid,
                  "verified": "0",
                  "filepath": allFileUrl.length > 0
                      ? allFileUrl[0]
                      : widget.isEdit!
                          ? userModel!.data!.user!.picture
                          : widget.allArtistData!.picture,
                  "genre": json.encode(["0"]),
                },
        ),
      );
      if (httpResult['ok']) {
        toastContainer(
          text: httpResult["data"]["msg"],
          backgroundColor: GREEN,
        );

        if (widget.allArtistData == null && widget.isEdit!) {
          GetUserDetailsProvider provider = GetUserDetailsProvider();
          userModel = await provider.fetch(
            token: userModel!.data!.token,
            userId: userModel!.data!.user!.userid,
          );
          navigation(context: context, pageName: "homepage");
          setState(() => _isLoading = false);
        } else {
          setState(() => _isLoading = false);
          navigation(context: context, pageName: "back");
        }
      } else {
        setState(() => _isLoading = false);
        toastContainer(text: httpResult["data"]["msg"], backgroundColor: RED);
      }
    }
  }

  Future<void> _onDOB() async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: datePickerTheme(),
          child: child!,
        );
      },
    );
    if (selected != null)
      setState(() {
        _dobController.text = selected.toIso8601String().split("T")[0];
      });
  }

  Future<void> _onUploadProfilePicture() async {
    File imagePath = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageCapture(),
      ),
    );
    // ignore: unnecessary_null_comparison
    if (imagePath != null)
      setState(() {
        _profilePic = imagePath.path;
        _isLocalUpload = true;
      });
  }

  void _onCountry(Country country) {
    _countryCode = country.isoCode;
    _phoneCode = country.phoneCode;
  }

  Future<void> _onGender() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select gender'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  setState(() {
                    _genderController.text = "Male";
                  });
                  Navigator.of(context).pop();
                  _unfocusAllNode();
                },
                child: const Text('Male', style: TextStyle(fontSize: 20)),
              ),
              Divider(),
              SimpleDialogOption(
                onPressed: () {
                  setState(() {
                    _genderController.text = "Female";
                  });
                  Navigator.of(context).pop();
                  _unfocusAllNode();
                },
                child: const Text('Female', style: TextStyle(fontSize: 20)),
              ),
            ],
          );
        });
  }
}
