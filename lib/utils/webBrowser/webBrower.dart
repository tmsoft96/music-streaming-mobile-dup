import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rally/spec/colors.dart';
// import 'package:rally/spec/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebBrowser extends StatefulWidget {
  final String? url, previousPage, title;
  final Map<String, dynamic>? meta;

  WebBrowser({
    @required this.previousPage,
    @required this.url,
    @required this.title,
    this.meta,
  });

  @override
  _WebBrowerState createState() => _WebBrowerState();
}

class _WebBrowerState extends State<WebBrowser> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  bool _isPageLoading = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onClose();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: BLACK),
            onPressed: () => _onClose(),
          ),
        ),
        body: Stack(
          children: [
            if (_isPageLoading)
              LinearProgressIndicator(
                  // value: double.parse(_progressValue.toString()),
                  ),
            Container(
              margin: EdgeInsets.only(top: _isPageLoading ? 4 : 0),
              child: Builder(
                builder: (BuildContext context) {
                  return WebView(
                    initialUrl: widget.url,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    onProgress: (int progress) {
                      print('WebView is loading (progress : $progress%)');
                      _isPageLoading = true;
                      // _progressValue = progress;
                      setState(() {});
                    },
                    navigationDelegate: (NavigationRequest request) {
                      print("request ${request.url}");
                      return NavigationDecision.navigate;
                    },
                    onPageStarted: (String url) {
                      print("page started $url");
                    },
                    onPageFinished: (String url) {
                      print("page finish $url");
                      if (widget.previousPage == "request") _getUrl(url);
                    },
                    gestureNavigationEnabled: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getUrl(String url) async {
    if (url.contains("/")) {
      List<String> splitUrl = url.split('/');
      print(splitUrl);
    }
  }

  void _onClose() {
    if (widget.previousPage == "back") {
      Navigator.of(context).pop();
    }
  }

  // bool _showCancelDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       contentTextStyle: TextStyle(color: WHITE),
  //       backgroundColor: BLACK2,
  //       title: Text(
  //         'Exit',
  //         style: TextStyle(color: WHITE),
  //       ),
  //       content: Text('Do you want to close browser?'),
  //       actions: <Widget>[
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(false),
  //           child: Text("No", style: h4Button),
  //         ),
  //         SizedBox(height: 16),
  //         TextButton(
  //           onPressed: () => _onClose(),
  //           child: Text("Yes", style: h4Button),
  //         ),
  //       ],
  //     ),
  //   );
  //   return false;
  // }
}
