import 'package:flutter/material.dart';
import 'package:rally/pages/authentication/login/loginPage.dart';
import 'package:rally/pages/authentication/register/registerAccount.dart';
import 'package:rally/pages/authentication/resetPassword/resetPassword.dart';
import 'package:rally/pages/homepage/mainHome.dart';
import 'package:rally/pages/modules/account/account/accountPage.dart';
import 'package:rally/pages/modules/account/deleteAccount/deleteAccount.dart';
import 'package:rally/pages/modules/account/enroll/enrollAsArtist.dart';
import 'package:rally/pages/modules/account/legal/legalPage.dart';
import 'package:rally/pages/modules/admin/adminHomepage/adminHomepage.dart';
import 'package:rally/pages/modules/admin/artist/adminViewAllArtist/tapPage/adminViewAllArtist.dart';
import 'package:rally/pages/modules/admin/banners/addBanner/addBanner.dart';
import 'package:rally/pages/modules/admin/banners/allBanners/allBanners.dart';
import 'package:rally/pages/modules/admin/completeArtistEnrollment/completeArtistEnrollment.dart';
import 'package:rally/pages/modules/admin/radio/addRadio/addRadio.dart';
import 'package:rally/pages/modules/admin/radio/adminRadio/adminRadioPage.dart';
import 'package:rally/pages/modules/admin/regularUsers/allRegularUsers.dart';
import 'package:rally/pages/modules/artists/artistContent/allArtistContent/allArtistContent.dart';
import 'package:rally/pages/modules/artists/artistHome/artistHomepage.dart';
import 'package:rally/pages/modules/artists/uploadContent/uploadContent1/uploadContent1.dart';
import 'package:rally/pages/modules/library/download/downloadLibrary/downloadLibrary.dart';
import 'package:rally/pages/modules/library/download/downloadOngoingPage/downloadOngoingPage.dart';
import 'package:rally/pages/modules/library/followings/followedArtists.dart';
import 'package:rally/pages/modules/library/recentlyPlayed/allRecentlyPlayed/allRecentlyPlayed.dart';
import 'package:rally/pages/modules/library/recentlyPlayed/recentPlayedDetail/recentlyPlayedDetails.dart';
import 'package:rally/pages/modules/music/genre/allGenres/allGenrePage.dart';
import 'package:rally/pages/homepage/searchMusic/searchMusic.dart';
import 'package:rally/pages/modules/library/playlists/myPlaylists/myPlayists.dart';
import 'package:rally/pages/modules/radio/searchPodcast/searchPodcast.dart';
import 'package:rally/pages/onboarding/onboardingPage.dart';
import 'package:rally/pages/onboarding/splashScreen.dart';

import '../pages/authentication/forgotPassword/forgetPassword/forgetPassword.dart';

void navigation({
  @required BuildContext? context,
  @required String? pageName,
}) {
  switch (pageName!.toLowerCase()) {
    case "back":
      Navigator.of(context!).pop();
      break;
    case "splashscreen":
      Navigator.of(context!).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => SplashScreen(),
          ),
          (Route<dynamic> route) => false);
      break;
    case "onboardingpage":
      Navigator.of(context!).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => OnboardingPage(),
          ),
          (Route<dynamic> route) => false);
      break;
    case "login":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      break;
    case "forgotpassword":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => ForgetPassword()),
      );
      break;
    case "resetpassword":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => ResetPassword()),
      );
      break;
    case "register":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => RegisterPage()),
      );
      break;
    case "homepage":
      Navigator.of(context!).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MainHome(),
          ),
          (Route<dynamic> route) => false);
      break;
    case "artisthomepage":
      Navigator.of(context!).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => ArtistHomepage(),
          ),
          (Route<dynamic> route) => false);
      break;
    case "adminhomepage":
      Navigator.of(context!).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => AdminHomepage(),
          ),
          (Route<dynamic> route) => false);
      break;
    case "genres":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => AllGenrePage()),
      );
      break;
    case "account":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => AccountPage()),
      );
      break;
    case "legal":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => LegalPage()),
      );
      break;
    case "enroll":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => EnrollAsArtist()),
      );
      break;
    case "uploadcontent":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => UploadContent1()),
      );
      break;
    case "allartistcontent":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => AllArtistContent()),
      );
      break;
    case "adminallartist":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => AdminViewAllArtist()),
      );
      break;
    case "adminradio":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => AdminRadioPage()),
      );
      break;
    case "followedartists":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => FollowedArtists()),
      );
      break;
    case "completeartistenrollment":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => CompleteArtistEnrollment()),
      );
      break;
    case "allregularusers":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => AllRegularUsers()),
      );
      break;
    case "allbanners":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => AllBanners()),
      );
      break;
    case "addbanner":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => AddBanner()),
      );
      break;
    case "addradio":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => AddRadio()),
      );
      break;
    case "searchradio":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => SearchPodcast()),
      );
      break;
    case "searchmusic":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => SearchMusic()),
      );
      break;
    case "downloadpage":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => DownloadPage()),
      );
      break;
    case "downloadlibrary":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => DownloadLibrary()),
      );
      break;
    case "myplaylists":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => MyPlaylists()),
      );
      break;
    case "deleteaccount":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => DeleteAccount()),
      );
      break;
    case "recentlyplayeddetails":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => RecentlyPlayedDetails()),
      );
      break;
    case "allrecentlyplayed":
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => AllRecentlyPlayed()),
      );
      break;
  }
}
