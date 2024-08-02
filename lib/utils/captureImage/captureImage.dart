import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rally/spec/styles.dart';

class ImageCapture extends StatefulWidget {
  final String? page;

  ImageCapture({this.page});

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  final imagePicker = ImagePicker();

  /// Active image file
  File? _imageFile;
  bool _isLoading = false;

  /// Cropper plugin
  Future<void> _cropImage() async {
    CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: _imageFile!.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: WHITE,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Image')
      ],
    );

    setState(() {
      _imageFile = cropped != null ? File(cropped.path) : _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final picker = await imagePicker.pickImage(source: source);
    File selected = File(picker!.path);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  Future<void> _done(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    final ByteData dbBytes = _imageFile!.readAsBytesSync().buffer.asByteData();
    try {
      File file = await writeToFile(dbBytes); // <= returns File
      print(file.path);
      testCompressAndGetFile(_imageFile!, file.path).then(
        (File path) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pop(context, path);
        },
      );
    } catch (e) {
      // catch errors here
      toastContainer(text: "Error uploading image", backgroundColor: RED);
    }
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 35,
      rotate: 0,
    );

    print(file.lengthSync());
    print(result!.lengthSync());

    return result;
  }

  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final String currentTime = DateTime.now().microsecondsSinceEpoch.toString();
    var filePath = tempPath + '/$currentTime.jpg';
    return new File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  @override
  void initState() {
    // _pickImage(ImageSource.gallery);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            if (_imageFile != null) ...[
              Container(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: _isLoading ? null : _clear,
                    ),
                    IconButton(
                      icon: Icon(Icons.crop),
                      onPressed: _isLoading ? null : _cropImage,
                    ),
                    button(
                      onPressed: () => _isLoading ? null : _done(context),
                      text: "Done",
                      color: PRIMARYCOLOR,
                      textColor: BLACK,
                      context: context,
                      useWidth: false,
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),

        // Select an image from the camera or gallery
        bottomNavigationBar: Container(
          height: 100,
          color: BLACK,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(
                  Icons.photo_camera,
                  size: 50,
                ),
                label: Text("Camera"),
                onPressed: () =>
                    _isLoading ? null : _pickImage(ImageSource.camera),
              ),
              SizedBox(width: 50),
              TextButton.icon(
                label: Text("Gallery"),
                icon: Icon(
                  Icons.photo_library,
                  size: 50,
                ),
                onPressed: () =>
                    _isLoading ? null : _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        ),

        body: Stack(
          children: <Widget>[
            Center(
              child: ListView(
                children: <Widget>[
                  if (_imageFile != null) ...[
                    Container(
                      height: MediaQuery.of(context).size.height * .7,
                      margin: EdgeInsets.all(20),
                      child: Image.file(_imageFile!),
                    ),
                  ] else
                    Container(
                      height: MediaQuery.of(context).size.height * .7,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.all(20),
                              child: ClipOval(
                                child: Image.asset(
                                  EMPTYBIG,
                                  width: 200,
                                  height: 200,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text("Upload picture", style: h4WhiteBold),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: BLACK.withOpacity(.8),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(BLACK),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
