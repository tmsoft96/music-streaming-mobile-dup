import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/downloadFIle.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/services.dart';
import 'package:rally/providers/allArtistsProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/properties.dart';

import 'widget/allContentsWidget.dart';

class AllContents extends StatefulWidget {
  final String? artistId, artistName, artistPicture, artistEmail;
  final String? followersCount, streamsCount;
  final List<String>? followersUserIdList;

  AllContents({
    @required this.artistId,
    @required this.artistName,
    @required this.artistEmail,
    @required this.artistPicture,
    @required this.followersCount,
    @required this.streamsCount,
    @required this.followersUserIdList,
  });

  @override
  State<AllContents> createState() => _AllContentsState();
}

class _AllContentsState extends State<AllContents> {
  bool _userFollowing = false, _isLoading = false;
  AllArtistsProvider _provider = new AllArtistsProvider();

  String _loadingMsg = "";
  double? _loadingPercentage;

  @override
  void initState() {
    super.initState();
    _checkUserFollow();
  }

  void _checkUserFollow() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (String followers in widget.followersUserIdList!) {
        print(followers);
        if (followers == userModel!.data!.user!.userid!) {
          _userFollowing = true;
          setState(() {});
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.artistName}"),
        actions: [
          IconButton(
            onPressed: () => _onShareContent(),
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: Stack(
        children: [
          allContentsWidget(
            artistId: widget.artistId,
            artistName: widget.artistName,
            artistEmail: widget.artistEmail,
            artistPicture: widget.artistPicture,
            context: context,
            followersCount: widget.followersCount,
            streamsCount: widget.streamsCount,
            onFollow: () => _onFollowArtist(),
            userFollowing: _userFollowing,
          ),
          if (_isLoading)
            customLoadingPage(
              msg: _loadingMsg,
              percent: _loadingPercentage,
            ),
        ],
      ),
    );
  }

  Future<void> _onShareContent() async {
    // TODO: WORK ON THIS
    String imageUrl = widget.artistPicture!;

    String fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
    String filePath = await getFilePath(fileName);
    await downloadFile(imageUrl, filePath: filePath, onProgress: (int rec,
        int total, String percentCompletedText, double percentCompleteValue) {
      print("$rec $total");
      setState(() {
        _loadingMsg = percentCompletedText;
        _loadingPercentage = percentCompleteValue;
      });
    }, onDownloadComplete: (String? savePath) async {
      _isLoading = false;
      _loadingPercentage = null;
      setState(() {});
      shareContent(
        text:
            "I just listen to ${widget.artistName} tracks. \n\nhttps://revoltafrica.net/ \n$TITLE, the Hub for fresh music",
        image: savePath,
      );
    });
  }

  Future<void> _onFollowArtist() async {
    setState(() => _isLoading = true);
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: FOLLOW_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "userid": widget.artistId,
          "follower": userModel!.data!.user!.userid,
        },
      ),
      showToastMsg: false,
    );
    log("$httpResult");
    if (httpResult["ok"]) {
      await _provider.get(isLoad: true, fetchArtistType: 0);
      _userFollowing = true;
      setState(() => _isLoading = false);
      toastContainer(text: httpResult["data"]["msg"], backgroundColor: GREEN);
    } else {
      setState(() => _isLoading = false);
      httpResult["statusCode"] == 200
          ? toastContainer(
              text: httpResult["data"]["msg"], backgroundColor: RED)
          : toastContainer(text: httpResult["error"], backgroundColor: RED);
    }
  }
}
