import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<void> downloadFile(
  String? url, {
  String? filePath,
  String? defaultFileName,
  @required
      void Function(int receive, int total, String precentCompletedText,
              double percentCompleteValue)?
          onProgress,
  @required void Function(String? savePath)? onDownloadComplete,
  bool useSupportDir = false,
  bool ignoreFileExit = false,
}) async {
  try {
    Dio dio = new Dio();
    String fileName = defaultFileName == null
        ? url!.substring(url.lastIndexOf("/") + 1)
        : defaultFileName;
    String savePath = filePath ??
        await getFilePath(
          fileName,
          useSupportDir: useSupportDir,
        );
    log(savePath);

    bool isExit = await File(savePath).exists();

    if (isExit && !ignoreFileExit) {
      onDownloadComplete!(savePath);
      return;
    }

    await dio.download(
      url!,
      savePath,
      onReceiveProgress: (receive, total) {
        String percentCompleted = "0%";
        double percentValue = 0;
        if (total != -1) {
          percentValue = receive / total * 100;
          percentCompleted = percentValue.toStringAsFixed(0) + "%";
        }
        onProgress!(receive, total, percentCompleted, percentValue);
      },
    );
    onDownloadComplete!(savePath);
  } catch (e) {
    print(e);
  }
}

Future<String> getFilePath(
  String uniqueFileName, {
  bool useSupportDir = true,
}) async {
  String path = '';

  Directory dir = useSupportDir
      ? await getApplicationSupportDirectory()
      : await getApplicationDocumentsDirectory();

  if (uniqueFileName.contains("?"))
    path = '${dir.path}/${uniqueFileName.split("?").first}';
  else
    path = '${dir.path}/$uniqueFileName';

  return path;
}
