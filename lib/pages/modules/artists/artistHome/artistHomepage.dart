import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/components/coolAlertDialog.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/offlineData.dart';
import 'package:rally/models/allFollowersModel.dart';
import 'package:rally/pages/modules/admin/completeArtistEnrollment/completeArtistEnrollment.dart';
import 'package:rally/providers/allFollowersProvider.dart';
import 'package:rally/providers/allMusicProvider.dart';
import 'package:rally/spec/images.dart';

import 'widget/artistHomepageWidget.dart';

class ArtistHomepage extends StatefulWidget {
  const ArtistHomepage({Key? key}) : super(key: key);

  @override
  _ArtistHomepageState createState() => _ArtistHomepageState();
}

class _ArtistHomepageState extends State<ArtistHomepage> {
  AllFollowersModel? _allFollowersModel;

  int _tabIndex = 0;
  bool _loadOnce = true;

  @override
  void initState() {
    super.initState();
    _loadAllFollower();
    _loadAllMusic();
  }

  Future<void> _loadAllFollower() async {
    AllFollowersProvider provider = AllFollowersProvider();
    await loadAllFollowerMapOffline();
    if (allFollowersMapOffline != null) {
      _allFollowersModel = AllFollowersModel.fromJson(
        json: allFollowersMapOffline,
        httpMsg: "Offline Data",
      );
      setState(() {});
    }
    _allFollowersModel = await provider.fetch(userModel!.data!.user!.userid);
    setState(() {});
  }

  Future<void> _loadAllMusic() async {
    AllMusicProvider provider = AllMusicProvider();
    await provider.get(
        isLoad: true, filterArtistId: userModel!.data!.user!.userid);
    setState(() {});
  }

  void _checkUserProfile() {
    _loadOnce = false;
    final user = userModel!.data!.user;
    if (user!.stageName == null &&
        (user.picture == null || user.picture == "")) {
      _onShowProfileDialog();
    }
  }

  void _onShowProfileDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      coolAlertDialog(
        context: context,
        onConfirmBtnTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CompleteArtistEnrollment(
                allArtistData: null,
                isEdit: true,
              ),
            ),
          );
        },
        type: CoolAlertType.info,
        text: "Your profile not complete",
        confirmBtnText: "Edit Profile",
        barrierDismissible: false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadOnce) _checkUserProfile();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("Artist"),
          actions: [
            GestureDetector(
              onTap: () => navigation(context: context, pageName: "account"),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: circular(
                  child: cachedImage(
                    context: context,
                    image: "${userModel!.data!.user!.picture!}",
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
        body: artistHomepageWidget(
          context: context,
          onHomepage: () => navigation(context: context, pageName: "homepage"),
          // onAddContent: () => navigation(
          //   context: context,
          //   pageName: "uploadcontent",
          // ),
          // onAddContent: () => callLauncher(
          //   "$UPLOADCONTENTFROMWEB_URL/${userModel!.data!.user!.userid}",
          // ),
          onAddContent: () => _showUploadWithLaptopDialog(),
          onNotification: () {},
          onSeeAllHits: () => navigation(
            context: context,
            pageName: "allartistcontent",
          ),
          onInviteFriend: () => inviteFrinds(),
          allFollowersModel: _allFollowersModel,
          allMusicModel: allMusicModel,
          onTap: (int index) {
            setState(() {
              _tabIndex = index;
            });
          },
          tabIndex: _tabIndex,
        ),
      ),
    );
  }

  void _showUploadWithLaptopDialog() {
    coolAlertDialog(
      context: context,
      onConfirmBtnTap: () {
        navigation(context: context, pageName: "back");
      },
      type: CoolAlertType.info,
      text: '''Content upload can only be done using computer

https://revoltafrica.net

1. Login to your Revolt Africa account on the website.
2. Click "Switch to artist" to access your artist dashboard.
3. On the artist dashboard navigate to "Upload Music" and  click on the "New Post" button.
4. Upload your music file from your device.
5. Proceed to fill out the music post details and submit.''',
      confirmBtnText: "Close",
    );
  }

  // void _onAddContent() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => WebBrowser(
  //         previousPage: 'back',
  //         title: "$TITLE",
  //         url: "$UPLOADCONTENTFROMWEB_URL/${userModel!.data!.user!.userid}",
  //       ),
  //     ),
  //   );
  // }
}
