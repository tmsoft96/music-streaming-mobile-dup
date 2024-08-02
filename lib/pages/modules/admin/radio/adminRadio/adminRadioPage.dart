import 'package:flutter/material.dart';
import 'package:rally/bloc/allPodcastBloc.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/offlineData.dart';
import 'package:rally/models/allPodcastModel.dart';

import 'widget/adminRadioWidget.dart';

class AdminRadioPage extends StatefulWidget {
  const AdminRadioPage({Key? key}) : super(key: key);

  @override
  State<AdminRadioPage> createState() => _AdminRadioPageState();
}

class _AdminRadioPageState extends State<AdminRadioPage> {
  @override
  void initState() {
    super.initState();
    loadAllPodcastMapOffline();
    allPodcastBloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Radio")),
      body: StreamBuilder(
        stream: allPodcastBloc.allPodcast,
        initialData: allPodcastMapOffline == null
            ? null
            : AllPodcastModel.fromJson(
                json: allPodcastMapOffline,
                httpMsg: "Offline Data",
              ),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.ok)
              return _mainContent(snapshot.data);
            else
              return allPodcastMapOffline == null
                  ? emptyBox(context, msg: "${snapshot.data.msg}")
                  : _mainContent(
                      AllPodcastModel.fromJson(
                        json: allPodcastMapOffline,
                        httpMsg: "Offline Data",
                      ),
                    );
          } else if (snapshot.hasError) {
            return emptyBox(context, msg: "No data available");
          }
          return shimmerItem();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigation(context: context, pageName: "addRadio"),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _mainContent(AllPodcastModel model) {
    return adminPodcastWidget(
      context: context,
      onSearch: () => navigation(context: context, pageName: "searchRadio"),
      model: model,
    );
  }
}
