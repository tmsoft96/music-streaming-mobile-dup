import 'package:flutter/material.dart';
import 'package:rally/bloc/allPodcastBloc.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/offlineData.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/pages/modules/admin/radio/adminUpcomingRadioDetails/adminUpcomingRadioDetails.dart';
import 'package:rally/spec/arrays.dart';

import '../podcastDetails/podcastDetailsPage.dart';
import 'widget/upcomingBroadcastWidget.dart';

class UpcomingBroadcast extends StatefulWidget {
  @override
  State<UpcomingBroadcast> createState() => _UpcomingBroadcastState();
}

class _UpcomingBroadcastState extends State<UpcomingBroadcast> {
  @override
  void initState() {
    super.initState();
    loadAllPodcastMapOffline();
    allPodcastBloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
                ? emptyBoxLinear(context, msg: "${snapshot.data.msg}")
                : _mainContent(
                    AllPodcastModel.fromJson(
                      json: allPodcastMapOffline,
                      httpMsg: "Offline Data",
                    ),
                  );
        } else if (snapshot.hasError) {
          return emptyBoxLinear(context, msg: "No data available");
        }
        return shimmerItem(useGrid: true);
      },
    );
  }

  Widget _mainContent(AllPodcastModel model) {
    return upcomingBroadcastWidget(
      context: context,
      onBroadcast: (AllRadioData data) => _onBroadcast(data),
      model: model,
    );
  }

  void _onBroadcast(AllRadioData data) {
    if (userModel!.data!.user!.role!.toLowerCase() == userTypeList[2])
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AdminUpcomingRadioDetails(data),
        ),
      );
    else
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PodcastcastDetailsPage(allRadioData: data),
        ),
      );
  }
}
