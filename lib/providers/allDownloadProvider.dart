import 'dart:convert';

import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/downloadFIle.dart';
import 'package:rally/config/hiveStorage.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/services.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rxdart/rxdart.dart';

final _fetcher = BehaviorSubject<AllDownloadModel>();
Sink<AllDownloadModel> get _fetcherSink => _fetcher.sink;
Stream<AllDownloadModel> get allDownloadStream => _fetcher.stream;
AllDownloadModel? allDownloadModel;
bool ongoingDownload = false;
List<Map<dynamic, dynamic>> ongoingDownloadQueue = [];

class AllDownloadProvider {
  Future<void> get() async {
    String? encodedData = await getHive("downloadFiles");
    // log(encodedData.toString());
    if (encodedData != null) {
      List<dynamic> decodedData = json.decode(encodedData);
      List<Map<dynamic, dynamic>> metaList =
          decodedData.cast<Map<dynamic, dynamic>>();
      AllDownloadModel model = AllDownloadModel.fromJson(
        {"data": metaList},
      );
      allDownloadModel = model;
      _fetcherSink.add(model);
      for (int x = 0; x < model.data!.length; ++x) {
        for (int y = 0; y < model.data![x].content!.length; ++y) {
          if (!model.data![x].content![y].downloaded!) {
            String fileUrl = model.data![x].content![y].filepath!;
            String fileName = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);
            String filePath = await getFilePath(fileName);
            await downloadFile(
              fileUrl,
              filePath: filePath,
              ignoreFileExit: true,
              onProgress: (
                int rec,
                int total,
                String percentCompletedText,
                double percentCompleteValue,
              ) {
                print("$rec $total");
                ongoingDownload = true;
                allDownloadModel = allDownloadMakedownload(
                  contentIndex: y,
                  percentDownloadCompleteValue: percentCompleteValue,
                  index: x,
                  model: allDownloadModel,
                );
                // if (ongoingDownloadQueue.isNotEmpty) {
                //   allDownloadModel = allDownloadAddDowonloadInfo(
                //     model: allDownloadModel,
                //     newDataList: ongoingDownloadQueue,
                //   );
                // }
                _fetcherSink.add(model);
              },
              onDownloadComplete: (String? savePath) async {
                httpChecker(
                  httpRequesting: () => httpRequesting(
                    endPoint: DOWNLOADMUSIC_URL,
                    method: HTTPMETHOD.POST,
                    httpPostBody: {
                      "userid": userModel!.data!.user!.userid,
                      "post_id": model.data![x].content![y].id,
                      "status": "0",
                    },
                    showLog: true,
                  ),
                  showToastMsg: false,
                );
                allDownloadModel = await allDownloadDownloadComplete(
                  model: allDownloadModel,
                  localFilePath: savePath,
                  contentIndex: y,
                  index: x,
                );
                toastContainer(
                  text:
                      "${model.data![x].content![y].title} finish downloading",
                  backgroundColor: GREEN,
                );
                _fetcherSink.add(model);
              },
            );
          }
        }
      }
    } else {
      AllDownloadModel model = AllDownloadModel.fromJson(
        {"data": null},
      );
      allDownloadModel = model;
      _fetcherSink.add(model);
    }
  }
}
