import 'package:flutter/material.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/spec/colors.dart';

import 'widget/downloadLibraryWidget.dart';

class DownloadLibrary extends StatefulWidget {
  const DownloadLibrary({Key? key}) : super(key: key);

  @override
  State<DownloadLibrary> createState() => _DownloadLibraryState();
}

class _DownloadLibraryState extends State<DownloadLibrary> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Downloads"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: PRIMARYCOLOR1,
              child: IconButton(
                color: BLACK,
                onPressed: () => navigation(
                  context: context,
                  pageName: "downloadpage",
                ),
                icon: Icon(Icons.download),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: allDownloadStream,
        initialData: allDownloadModel ?? null,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.data == null) {
              _tabIndex = -1;
              WidgetsBinding.instance.addPostFrameCallback((_) => setState((){}));
            }
            return snapshot.data.data != null
                ? _mainContent(snapshot.data)
                : emptyBox(context, msg: "No download file available");
          } else if (snapshot.hasError) {
            return emptyBox(context, msg: "No download file available");
          }
          return shimmerItem(numOfItem: 6);
        },
      ),
    );
  }

  Widget _mainContent(AllDownloadModel model) {
    return downloadLibraryWidget(
      onTap: (int index) {
        setState(() {
          _tabIndex = index;
        });
      },
      tabIndex: _tabIndex,
      model: model,
    );
  }
}
