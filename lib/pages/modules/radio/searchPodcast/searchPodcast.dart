import 'package:flutter/material.dart';
import 'package:rally/bloc/allPodcastBloc.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/offlineData.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/pages/modules/admin/radio/adminUpcomingRadioDetails/adminUpcomingRadioDetails.dart';
import 'package:rally/spec/arrays.dart';

import '../podcastDetails/podcastDetailsPage.dart';
import 'widget/searchPodcastLoading.dart';
import 'widget/searchPodcastNoTextWdget.dart';
import 'widget/searchPodcastTextWidget.dart';
import 'widget/searchTextBox.dart';

class SearchPodcast extends StatefulWidget {
  const SearchPodcast({Key? key}) : super(key: key);

  @override
  State<SearchPodcast> createState() => _SearchPodcastState();
}

class _SearchPodcastState extends State<SearchPodcast> {
  FocusNode? _searchFocusNode;
  String _searchText = "";

  final _searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchFocusNode = new FocusNode();
    loadAllPodcastMapOffline();
    allPodcastBloc.fetch();
  }

  @override
  void dispose() {
    super.dispose();
    _searchFocusNode!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
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
      ),
    );
  }

  Widget _mainContent(AllPodcastModel model) {
    return Stack(
      children: [
        searchTextBox(
          onSearchChange: (String text) => setState(() => _searchText = text),
          searchFocusNode: _searchFocusNode,
          searchController: _searchController,
        ),
        Container(
          margin: EdgeInsets.only(top: 70),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (_searchText == "")
                  searchRadioNoTextWdget(
                    context: context,
                    onTag: (String name) => _onTag(name),
                    model: model,
                    searchText: _searchText,
                  ),
                if (_searchText != "" && _searchText.length < 2)
                  searchLoading(context),
                if (_searchText.length > 1)
                  searchPodcastTextWidget(
                    context: context,
                    model: model,
                    onPodcast: (AllRadioData data) => _onBroadcast(data),
                    searchText: _searchText,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onTag(String name) {
    _searchController.text = name;
    _searchText = name;
    setState(() {});
    _searchFocusNode!.unfocus();
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
