import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/components/trackMoreWidget.dart';
import 'package:rally/config/firebase/firebaseDynamicLink.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/allAlbumModel.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/pages/modules/account/reportContent/addReport.dart';
import 'package:rally/pages/modules/artists/allContents/allContentsPage.dart';
import 'package:rally/pages/modules/artists/artistContent/allArtistContent/allArtistContent.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/createPlaylists.dart';
import 'package:rally/pages/modules/music/album/albumsDetails/albumsDetailsPage.dart';
import 'package:rally/providers/allAlbumProvider.dart';
import 'package:rally/providers/allArtistsProvider.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

import 'widget/artistAlbumsWidget.dart';

class ArtistAlbums extends StatefulWidget {
  final String? artistId, artistName;

  ArtistAlbums({
    @required this.artistId,
    @required this.artistName,
  });

  @override
  State<ArtistAlbums> createState() => _ArtistAlbumsState();
}

class _ArtistAlbumsState extends State<ArtistAlbums> {
  String _artistName = "";

  AllAlbumProvider _provider = new AllAlbumProvider();
  FirebaseDynamicLink _firebaseDynamicLink = new FirebaseDynamicLink();

  @override
  void initState() {
    super.initState();
    if (widget.artistName!.contains("ft"))
      _artistName = widget.artistName!.split("ft")[0];
    else
      _artistName = widget.artistName!;

    _provider.get(isLoad: true, status: "0", filterArtistId: widget.artistId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: allAlbumModelStream,
      initialData: allAlbumModel ?? null,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.ok)
            return _mainContent(snapshot.data);
          else
            return allAlbumModel == null
                ? emptyBoxLinear(context, msg: "${snapshot.data.msg}")
                : _mainContent(allAlbumModel!);
        } else if (snapshot.hasError) {
          return emptyBoxLinear(context, msg: "No data available");
        }
        return shimmerItem(useGrid: true);
      },
    );
  }

  Widget _mainContent(AllAlbumModel model) {
    return artistAlbumsWidget(
      context: context,
      onSeeAll: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AllArtistContent(
            artistId: widget.artistId,
          ),
        ),
      ),
      onAlbum: (AllAlbumData data) => _onAlbum(data),
      artistName: _artistName,
      model: model,
      onAlbumMore: (AllAlbumData data) => _onTrackMore(data),
      onPlayAlbum: (AllAlbumData data) => _onPlayAlbum(data),
    );
  }

  void _onPlayAlbum(AllAlbumData data) {
    Map<String, dynamic> json = {
      "data": [
        for (var file in data.files!)
          {
            "id": data.id,
            "title": file.name,
            "lyrics": file.lyrics,
            "stageName": data.stageName,
            "filepath": file.filepath,
            "cover": data.media!.thumb,
            "thumb": data.media!.thumb,
            "thumbnail": data.media!.thumbnail,
            "isCoverLocal": false,
            "description": data.description,
            "artistId": data.userid,
          },
      ]
    };
    PlayerModel playerModel = PlayerModel.fromJson(json);
    onHideOverlay();
    final musicInitialize = MusicInitialize(playerModel: playerModel);
    if (player != null) musicInitialize.dispose();
    musicInitialize.init();
    showMaterialModalBottomSheet(
      context: context,
      expand: false,
      enableDrag: false,
      backgroundColor: TRANSPARENT,
      builder: (context) => MusicPlayer(playerModel: playerModel),
    );
  }

  void _onTrackMore(AllAlbumData data) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return trackMoreWidget(
          context: context,
          contentImage: data.media!.thumb,
          onClose: () => navigation(context: context, pageName: "back"),
          artistName: data.stageName,
          title: data.name,
          artistPicture: null,
          onAddToPlaylist: () => _onAddToPlaylist(data),
          onArtistProfile: () => _onArtistProfile(data),
          onFavorite: () => _onFavorite(data),
          onMoreInfo: () => _onAlbum(data),
          onReport: () => _onReport(data),
          onShare: () => _onShare(data),
          onDownload: () => _onDownloadAlbum(data),
          contentId: data.id.toString(),
          contentType: "album",
        );
      },
    );
  }

  void _onDownloadAlbum(AllAlbumData data) {
    if (ongoingDownload) {
      toastContainer(
        text: "Download on going please wait for it to finish",
        backgroundColor: RED,
      );
      return;
    }

    Map<dynamic, dynamic> meta = {
      "id": "album${data.id}",
      "cover": data.cover,
      "title": data.name,
      "artistName": data.stageName,
      "description": data.description,
      "createAt": DateTime.now().millisecondsSinceEpoch,
      "fileDownloaded": false,
      "content": [
        for (var content in data.files!)
          {
            "id": content.id,
            "title": content.name,
            "lyrics": content.lyrics,
            "stageName": data.stageName,
            "filepath": content.filepath,
            "cover": data.cover,
            "thumbnail": data.media!.thumbnail,
            "isCoverLocal": false,
            "description": data.description,
            "artistId": data.userid,
            "downloaded": false,
            "localFile": null,
            "isDownloading": true,
          },
      ],
    };

    contentDownload(meta);
  }

  Future<void> _onShare(AllAlbumData data) async {
    toastContainer(text: "Please wait", backgroundColor: GREEN);
    String text = "${data.name!} by ${data.stageName}";

    String imageUrl = data.media!.thumbnail!;
    String generatedLink = await _firebaseDynamicLink.createDynamicLink(
      albumId: data.id.toString(),
      albumUrlHash: data.urlHash,
      singleMusicId: null,
      playlistid: null,
      imageUrl: imageUrl,
      title: text,
    );
    print(generatedLink);
    shareContent(text: generatedLink);
  }

  void _onReport(AllAlbumData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (content) => AddReport(
          albumId: data.id.toString(),
          postId: null,
          radioId: null,
        ),
      ),
    );
  }

  void _onArtistProfile(AllAlbumData albumData) {
    for (var data in allArtistsModel!.data!)
      if (albumData.userid == data.userid) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AllContents(
              artistId: data.userid,
              artistName: data.stageName ?? data.name,
              artistEmail: data.email,
              artistPicture: data.picture,
              followersCount: data.followersCount,
              followersUserIdList: [
                for (var followers in data.followers!) followers.followerId!
              ],
              streamsCount: data.streamsCount,
            ),
          ),
        );
        break;
      }
  }

  void _onAddToPlaylist(AllAlbumData data) {
    Map<String, dynamic> json = {
      "data": [
        for (var file in data.files!)
          {
            "id": file.id,
            "title": file.name,
            "lyrics": file.lyrics,
            "stageName": data.stageName,
            "filepath": file.filepath,
            "cover": data.media!.normal,
            "thumb": data.media!.thumb,
            "thumbnail": data.media!.thumbnail,
            "isCoverLocal": false,
            "description": data.description,
            "artistId": data.userid,
          },
      ]
    };
    PlayerModel playerModel = PlayerModel.fromJson(json);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreatePlaylists(playerModel: playerModel),
      ),
    );
  }

  void _onFavorite(AllAlbumData data) {
    // setState(() => _isLoading = true);
    saveDeleteContentFavorite(
      contentId: data.id.toString(),
      state: () {
        // setState(() => _isLoading = false);
      },
      type: "album",
    );
  }

  void _onAlbum(AllAlbumData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AlbumsDetailsPage(
          allAlbumData: data,
          allMusicData: null,
        ),
      ),
    );
  }
}
