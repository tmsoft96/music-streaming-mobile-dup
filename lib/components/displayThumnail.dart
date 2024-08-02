// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:photo_manager/photo_manager.dart';

// import '../config/downloadFIle.dart';
// import '../config/globalFunction.dart';
// import '../spec/colors.dart';
// import '../spec/images.dart';

// class DisplayThucmnail extends StatefulWidget {
//   final String? image;
//   final double? height, width;
//   final String? placeholder;
//   final BoxFit? fit;
//   final int? thumbnailSize;
//   final bool? isOfflineData;

//   DisplayThumnail({
//     @required this.height,
//     @required this.width,
//     @required this.image,
//     this.placeholder = IMAGELOADINGERROROFFLINE,
//     this.fit = BoxFit.cover,
//     this.thumbnailSize = 130,
//     this.isOfflineData = false,
//   });

//   @override
//   State<DisplayThumnail> createState() => _DisplayThumnailState();
// }

// class _DisplayThumnailState extends State<DisplayThumnail> {
//   AssetEntity? _imageEntityWithPath;
//   bool _noImage = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.image != "") {
//       _downloadImage();
//     } else {
//       _noImage = true;
//     }
//   }

//   Future<void> _downloadImage() async {
//     String fileName = widget.image!.replaceAll("/", "");
//     if (widget.isOfflineData!) {
//       _imageEntityWithPath = await PhotoManager.editor.saveImageWithPath(
//         widget.image!,
//         title: fileName,
//       );
//       setState(() {});
//     } else {
//       fileName = fileName.replaceAll(
//         "https:admin.revoltafrica.",
//         "$thumbnailPathSplitter",
//       );
//       String filePath = await getFilePath(fileName);
//       print(filePath);
//       await downloadFile(
//         widget.image,
//         filePath: filePath,
//         useSupportDir: true,
//         onProgress: (
//           int rec,
//           int total,
//           String percentCompletedText,
//           double percentCompleteValue,
//         ) {
//           print("$rec $total");
//         },
//         onDownloadComplete: (String? savePath) async {
//           PhotoManager.setIgnorePermissionCheck(true);
//           _imageEntityWithPath = await PhotoManager.editor.saveImageWithPath(
//             savePath!,
//             title: fileName,
//           );
//           setState(() {});
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: widget.width,
//       height: widget.height,
//       child: _noImage
//           ? Image.asset(
//               widget.placeholder!,
//               height: widget.height,
//               width: widget.width,
//               fit: widget.fit,
//             )
//           : _imageEntityWithPath == null
//               ? _loading()
//               : AssetEntityImage(
//                   _imageEntityWithPath!,
//                   isOriginal: false, // Defaults to `true`.
//                   thumbnailSize: ThumbnailSize.square(
//                     widget.thumbnailSize!,
//                   ), // Preferred value 200.
//                   thumbnailFormat: ThumbnailFormat.jpeg, // Defaults to `jpeg`.
//                   height: widget.height,
//                   width: widget.width,
//                   fit: widget.fit,
//                   // loadingBuilder: (context, child, loadingProgress) => _loading(),
//                   errorBuilder: (context, error, stackTrace) => Image.asset(
//                     widget.placeholder!,
//                     height: widget.height,
//                     width: widget.width,
//                     fit: widget.fit,
//                   ),
//                 ),
//     );
//   }

//   Widget _loading() {
//     return Center(
//       child: SizedBox(
//         width: 30,
//         height: 30,
//         child: CircularProgressIndicator(
//           valueColor: new AlwaysStoppedAnimation<Color>(PRIMARYCOLOR),
//         ),
//       ),
//     );
//   }
// }
