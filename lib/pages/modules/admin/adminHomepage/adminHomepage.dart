import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/offlineData.dart';
import 'package:rally/models/allArtistsModel.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/models/allRegularUserModel.dart';
import 'package:rally/pages/modules/admin/adminHomepage/widget/adminHomepageWidget.dart';
import 'package:rally/pages/modules/artists/allArtists/allArtists.dart';
import 'package:rally/providers/allArtistsProvider.dart';
import 'package:rally/providers/allMusicProvider.dart';
import 'package:rally/providers/allPodcastProvider.dart';
import 'package:rally/providers/allRegularUserProvider.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

class AdminHomepage extends StatefulWidget {
  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  AllArtistsModel? _allApprovedArtistsModel,
      _allPendingArtistsModel,
      _allDeclinedArtistsModel;
  AllRegularUserModel? _allRegularUserModel;
  AllPodcastModel? _allRadioModel;

  @override
  void initState() {
    super.initState();
    _loadAllMusic();
    _loadAllArtist();
    _loadAllRegularUsers();
    _loadAllRadio();
  }

  Future<void> _loadAllMusic() async {
    AllMusicProvider provider = AllMusicProvider();
    await provider.get(isLoad: true, filterArtistId: null);
    setState(() {});
  }

  Future<void> _loadAllArtist() async {
    _allPendingArtistsModel = null;
    _allDeclinedArtistsModel = null;
    setState(() {});
    AllArtistsProvider provider = AllArtistsProvider();
    _allApprovedArtistsModel = await provider.fetch(0);
    setState(() {});
    _allPendingArtistsModel = await provider.fetch(1);
    setState(() {});
    _allDeclinedArtistsModel = await provider.fetch(2);
    setState(() {});
  }

  Future<void> _loadAllRegularUsers() async {
    AllRegularUserProvider provider = AllRegularUserProvider();
    await loadAllRegularUserMapOffline();
    if (allRegularUserMapOffline != null) {
      _allRegularUserModel = AllRegularUserModel.fromJson(
        json: allRegularUserMapOffline,
        httpMsg: "Offline Data",
      );
      setState(() {});
    }
    _allRegularUserModel = await provider.fetch();
    setState(() {});
  }

  Future<void> _loadAllRadio() async {
    AllPodcastProvider provider = AllPodcastProvider();
    await loadAllPodcastMapOffline();
    if (allPodcastMapOffline != null) {
      _allRadioModel = AllPodcastModel.fromJson(
        json: allPodcastMapOffline,
        httpMsg: "Offline Data",
      );
      setState(() {});
    }
    _allRadioModel = await provider.fetch();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          titleTextStyle: h2WhiteBold,
          centerTitle: false,
          title: Text("Admin"),
          actions: [
            GestureDetector(
              onTap: () => navigation(context: context, pageName: "account"),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: circular(
                  child: cachedImage(
                    context: context,
                    image: userModel!.data!.user!.picture,
                    height: 40,
                    width: 40,
                    placeholder: DEFAULTPROFILEPICOFFLINE,
                  ),
                  size: 40,
                ),
              ),
            )
          ],
        ),
        body: adminHomepageWidget(
          context: context,
          onHomepage: () => navigation(
            context: context,
            pageName: "homepage",
          ),
          onNotification: () {},
          onLogs: () {},
          onArtist: () => navigation(
            context: context,
            pageName: "adminallartist",
          ),
          onRadio: () => navigation(context: context, pageName: "adminradio"),
          onUsers: () => navigation(
            context: context,
            pageName: "allregularusers",
          ),
          onAllTopArtists: () => _onAllTopArtists(),
          allMusicModel: allMusicModel,
          allApprovedArtistsModel: _allApprovedArtistsModel,
          allDeclinedArtistsModel: _allDeclinedArtistsModel,
          allPendingArtistsModel: _allPendingArtistsModel,
          allRegularUserModel: _allRegularUserModel,
          allRadioModel: _allRadioModel,
          onBanner: () => navigation(context: context, pageName: "allBanners"),
        ),
      ),
    );
  }

  void _onAllTopArtists() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text("All Artists")),
          body: AllArtists(noOfContentDisplay: -1000),
        ),
      ),
    );
  }
}
