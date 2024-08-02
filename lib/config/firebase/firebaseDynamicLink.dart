import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:rally/pages/homepage/mainHome.dart';
import 'package:rally/spec/properties.dart';

Stream<String>? deepLinkSongIdStream;
Stream<String>? deepLinkAlbumIdStream;

class FirebaseDynamicLink {
  FirebaseDynamicLinks _dynamicLinks = FirebaseDynamicLinks.instance;

  Future<String> createDynamicLink({
    @required String? singleMusicId,
    @required String? albumUrlHash,
    @required String? albumId,
    @required String? playlistid,
    @required String? imageUrl,
    @required String? title,
    String description = "$TITLE, the Hub for fresh music",
    String? bannerId,
    bool shortLink = true,
  }) async {
    String _linkMessage;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://revoltafrica.page.link',
      link: Uri.parse(
        albumUrlHash != null && albumId != null
            ? 'https://revoltafrica.net/albums/$albumUrlHash?id=$albumId'
            : singleMusicId != null
                ? 'https://revoltafrica.net/songs/$singleMusicId?id=$singleMusicId'
                : playlistid != null
                    ? 'https://revoltafrica.net/playlists/$playlistid?id=$playlistid'
                    : 'https://revoltafrica.net/banner/$bannerId?id=$bannerId',
      ),
      androidParameters: AndroidParameters(
        packageName: 'com.cc77Developers.rally',
        minimumVersion: BUILDNUMBER,
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.77developers.revolt-africa2',
        minimumVersion: VERSIONONLY,
        appStoreId: APPSTOREID,
      ),
      // googleAnalyticsParameters: GoogleAnalyticsParameters(
      //   campaign: 'example-promo',
      //   medium: 'social',
      //   source: 'orkut',
      // ),
      // itunesConnectAnalyticsParameters: ITunesConnectAnalyticsParameters(
      //   providerToken: '123456',
      //   campaignToken: 'example-promo',
      // ),
      socialMetaTagParameters:
          imageUrl != null && title != null
              ? SocialMetaTagParameters(
                  title: title,
                  description: description,
                  imageUrl: Uri.parse(imageUrl),
                )
              : null,
    );

    Uri _url;
    if (shortLink) {
      final ShortDynamicLink shortLink =
          await _dynamicLinks.buildShortLink(parameters);
      _url = shortLink.shortUrl;
    } else {
      _url = await _dynamicLinks.buildLink(parameters);
    }

    _linkMessage = _url.toString();
    return _linkMessage;
  }

  Future<void> initDynamicLink(BuildContext context) async {
    _dynamicLinks.onLink.listen((PendingDynamicLinkData dynamicLinkData) {
      final deepLink = dynamicLinkData.link;
      print("deepLinkSongId deepLink $deepLink");

      bool isSong = deepLink.pathSegments.contains("songs");
      bool isAlbum = deepLink.pathSegments.contains("albums");

      if (isSong) {
        String? id = deepLink.queryParameters["id"];
        deepLinkSongIdStream = Stream.value("$id");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => MainHome(),
            ),
            (Route<dynamic> route) => false);
      } else if (isAlbum) {
        String? id = deepLink.queryParameters["id"];
        deepLinkAlbumIdStream = Stream.value("$id");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => MainHome(),
            ),
            (Route<dynamic> route) => false);
      }
      return;
    }).onError((error) {
      print('onLink error');
      print(error.message);
      return;
    });

    final PendingDynamicLinkData? data = await _dynamicLinks.getInitialLink();
    if (data != null) {
      Uri url = data.link;

      print("deepLinkSongId PendingDynamicLinkData $url");
      bool isSong = url.pathSegments.contains("songs");
      bool isAlbum = url.pathSegments.contains("albums");

      if (isSong) {
        String? id = url.queryParameters["id"];
        deepLinkSongIdStream = Stream.value("$id");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => MainHome(),
            ),
            (Route<dynamic> route) => false);
      } else if (isAlbum) {
        String? id = url.queryParameters["id"];
        deepLinkAlbumIdStream = Stream.value("$id");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => MainHome(),
            ),
            (Route<dynamic> route) => false);
      }
      return;
    } else {
      return;
    }
  }
}
