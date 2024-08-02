import 'package:flutter/material.dart';
import 'package:rally/bloc/allPodcastBloc.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/trackMoreWidget.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/offlineData.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/pages/modules/admin/radio/adminUpcomingRadioDetails/adminUpcomingRadioDetails.dart';
import 'package:rally/spec/arrays.dart';

import '../podcastDetails/podcastDetailsPage.dart';
import 'widget/topPodcastShowFullWidget.dart';
import 'widget/topPodcastShowWidget.dart';

class TopPodcastShow extends StatefulWidget {
  final bool fromAdminPage;
  final int? noOfContentDisplay;

  TopPodcastShow({
    this.fromAdminPage = false,
    this.noOfContentDisplay,
  });

  @override
  State<TopPodcastShow> createState() => _TopPodcastShowState();
}

class _TopPodcastShowState extends State<TopPodcastShow> {
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
                ? widget.noOfContentDisplay == -1000
                    ? emptyBox(context, msg: "${snapshot.data.msg}")
                    : emptyBoxLinear(context, msg: "${snapshot.data.msg}")
                : _mainContent(
                    AllPodcastModel.fromJson(
                      json: allPodcastMapOffline,
                      httpMsg: "Offline Data",
                    ),
                  );
        } else if (snapshot.hasError) {
          return widget.noOfContentDisplay == -1000
              ? emptyBox(context, msg: "No data available")
              : emptyBoxLinear(context, msg: "No data available");
        }
        return shimmerItem(useGrid: true);
      },
    );
  }

  Widget _mainContent(AllPodcastModel model) {
    return widget.noOfContentDisplay == -1000
        ? topPodcastShowFullWidget(
            context: context,
            onShow: (AllRadioData data) => _onShow(data),
            model: model,
            onBroadcastMore: (AllRadioData data) => onBroadcastMore(data),
            // TODO: WORK HERE PODCAST
            onBroadcastPlay: (AllRadioData data) {},
          )
        : topPodcastShowWidget(
            context: context,
            onSeeAll: () => _onSeeAll(),
            onShow: (AllRadioData data) => _onShow(data),
            fromAdminPage: widget.fromAdminPage,
            model: model,
            onBroadcastMore: (AllRadioData data) => onBroadcastMore(data),
            // TODO: WORK HERE PODCAST
            onBroadcastPlay: (AllRadioData data) {},
          );
  }

  void onBroadcastMore(AllRadioData data) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return trackMoreWidget(
          context: context,
          contentImage: data.cover,
          onClose: () => navigation(context: context, pageName: "back"),
          artistName: data.stageName,
          title: data.title,
          artistPicture: data.user!.picture,
          // TODO: WORK HERE PODCAST
          onAddToPlaylist: () {},
          onArtistProfile: () {},
          onFavorite: () {},
          onMoreInfo: () {},
          onReport: () {},
          onShare: () {},
          onDownload: () {}, 
          contentId: data.id.toString(),
          contentType: 'podcast',
        );
      },
    );
  }

  void _onSeeAll() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text("Top Shows")),
          body: TopPodcastShow(noOfContentDisplay: -1000),
        ),
      ),
    );
  }

  void _onShow(AllRadioData data) {
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
