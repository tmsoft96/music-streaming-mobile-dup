import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/components/trackMoreWidget.dart';
import 'package:rally/config/firebase/firebaseDynamicLink.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/models/queueModel.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/pages/modules/account/reportContent/addReport.dart';
import 'package:rally/pages/modules/artists/allContents/allContentsPage.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/createPlaylists.dart';
import 'package:rally/pages/modules/music/genre/genreDetails/genreDetails.dart';
import 'package:rally/pages/modules/radio/searchPodcast/widget/searchPodcastLoading.dart';
import 'package:rally/providers/allArtistsProvider.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/allMusicProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

import '../../modules/music/album/albumsDetails/albumsDetailsPage.dart';
import 'widget/searchMusicNoTextWdget.dart';
import 'widget/searchMusicTextWidget.dart';
import 'widget/searchTextBox.dart';

class SearchMusic extends StatefulWidget {
  @override
  State<SearchMusic> createState() => _SearchMusicState();
}

class _SearchMusicState extends State<SearchMusic> {
  FocusNode? _searchFocusNode;
  String _searchText = "";

  final _searchController = new TextEditingController();
  AllMusicProvider _provider = AllMusicProvider();

  FirebaseDynamicLink _firebaseDynamicLink = new FirebaseDynamicLink();

  bool _isLoading = false;
  String _loadingMsg = "";

  double? _loadingPercentage;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = new FocusNode();
    _provider.get(isLoad: false, filterArtistId: null);
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
          stream: allMusicModelStream,
          // initialData: allMusicModel ?? null,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.ok)
                return _mainContent(snapshot.data);
              else
                return emptyBox(context, msg: "${snapshot.data.msg}");
            } else if (snapshot.hasError) {
              return emptyBox(context, msg: "No data available");
            }
            return shimmerItem(numOfItem: 6);
          },
        ),
      ),
    );
  }

  Widget _mainContent(AllMusicModel model) {
    return Stack(
      children: [
        searchTextBox(
          onSearchChange: (String text) => setState(() => _searchText = text),
          searchFocusNode: _searchFocusNode,
          searchController: _searchController,
          onClear: () => _onClearSearchText(),
        ),
        Container(
          margin: EdgeInsets.only(top: 70),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (_searchText == "")
                  searchMusicNoTextWdget(
                    content: context,
                    onTag: (String name) => _onTag(name),
                    model: model,
                    onGenre: (String genre) => _onGenre(genre, model),
                  ),
                if (_searchText != "" && _searchText.length < 2)
                  searchLoading(context),
                if (_searchText.length > 1)
                  searchMusicTextWidget(
                    context: context,
                    model: model,
                    onMusic: (AllMusicData data) => _onMusic(data, model),
                    searchText: _searchText,
                    onMusicMore: (AllMusicData data) =>
                        _onTrackMore(data, model),
                    onMusicPlay: (AllMusicData data) =>
                        _onPlayTrack(data, model),
                  ),
              ],
            ),
          ),
        ),
        if (_isLoading)
          customLoadingPage(
            msg: _loadingMsg,
            percent: _loadingPercentage,
          ),
      ],
    );
  }

  void _onPlayTrack(AllMusicData data, AllMusicModel model) {
    Map<String, dynamic> json = {
      "data": [
        {
          "id": data.id,
          "title": data.title,
          "lyrics": data.lyrics,
          "stageName": data.stageName,
          "filepath": data.filepath,
          "cover": data.media!.normal,
          "thumb": data.media!.thumb,
          "isCoverLocal": false,
          "description": data.description,
          "artistId": data.userid,
        },
        for (int x = 0;
            x < (model.data!.length > 50 ? 50 : model.data!.length);
            ++x)
          if (data.id != model.data![x].id)
            {
              "id": model.data![x].id,
              "title": model.data![x].title,
              "lyrics": model.data![x].lyrics,
              "stageName": model.data![x].stageName,
              "filepath": model.data![x].filepath,
              "cover": model.data![x].media!.normal,
              "thumbnail":  model.data![x].media!.thumbnail,
              "thumb": model.data![x].media!.thumb,
              "isCoverLocal": false,
              "description": model.data![x].description,
              "isQueue": true,
            },
      ],
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

  void _onTrackMore(AllMusicData data, AllMusicModel model) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return trackMoreWidget(
          context: context,
          contentImage: data.media!.thumb,
          onClose: () => navigation(context: context, pageName: "back"),
          artistName: data.stageName,
          title: data.title,
          artistPicture: data.user!.picture,
          onAddToPlaylist: () => _onAddToPlaylist(data),
          onArtistProfile: () => _onArtistProfile(data),
          onFavorite: () => _onFavorite(data),
          onMoreInfo: () => _onMusic(data, model),
          onReport: () => _onReport(data),
          onShare: () => _onShare(data),
          onDownload: () => _onDownload(data),
          contentId: data.id.toString(),
          contentType: 'single',
        );
      },
    );
  }

  void _onDownload(AllMusicData data) {
    if (ongoingDownload) {
      toastContainer(
        text: "Download on going please wait for it to finish",
        backgroundColor: RED,
      );
      return;
    }

    Map<dynamic, dynamic> meta = {
      "id": "single${data.id}",
      "cover": data.media!.thumb,
      "title": data.title,
      "artistName": data.user!.stageName ?? data.user!.name,
      "description": data.description,
      "createAt": DateTime.now().millisecondsSinceEpoch,
      "fileDownloaded": false,
      "content": [
        {
          "id": data.id.toString(),
          "title": data.title,
          "lyrics": data.lyrics,
          "stageName": data.stageName,
          "filepath": data.filepath,
          "cover": data.media!.thumb,
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

  Future<void> _onShare(AllMusicData data) async {
    String text = "${data.title!} by ${data.stageName}";

    String imageUrl = data.media!.thumbnail!;

    toastContainer(text: "Please wait", backgroundColor: GREEN);
    String generatedLink = await _firebaseDynamicLink.createDynamicLink(
      albumId: null,
      albumUrlHash: null,
      singleMusicId: data.id.toString(),
      playlistid: null,
      imageUrl: imageUrl,
      title: text,
    );
    print(generatedLink);

    shareContent(text: generatedLink);
  }

  void _onReport(AllMusicData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (content) => AddReport(
          albumId: null,
          postId: data.id.toString(),
          radioId: null,
        ),
      ),
    );
  }

  void _onArtistProfile(AllMusicData musicData) {
    for (var data in allArtistsModel!.data!)
      if (musicData.userid == data.userid) {
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

  void _onAddToPlaylist(AllMusicData data) {
    Map<String, dynamic> json = {
      "data": [
        {
          "id": data.id,
          "title": data.title,
          "lyrics": data.lyrics,
          "stageName": data.stageName,
          "filepath": data.filepath,
          "cover": data.cover,
          "thumbnail":  data.media!.thumbnail,
          "thumb": data.media!.thumb,
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

  void _onFavorite(AllMusicData data) {
    // setState(() => _isLoading = true);
    saveDeleteContentFavorite(
      contentId: data.id.toString(),
      state: () {
        // setState(() => _isLoading = false);
      },
      type: "single",
    );
  }

  void _onGenre(String genre, AllMusicModel model) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GenreDetails(
          allMusicModel: model,
          genreName: genre,
        ),
      ),
    );
  }

  void _onClearSearchText() {
    _searchText = "";
    _searchFocusNode!.unfocus();
    _searchController.clear();
    setState(() {});
  }

  void _onMusic(AllMusicData data, AllMusicModel model) {
    AllMusicModel s = model;
    Map<String, dynamic> json = {
      "data": [
        for (int x = 0; x < (s.data!.length > 50 ? 50 : s.data!.length); ++x)
          {
            "id": s.data![x].id,
            "title": s.data![x].title,
            "lyrics": s.data![x].lyrics,
            "stageName": s.data![x].stageName,
            "filepath": s.data![x].filepath,
            "cover": s.data![x].media!.normal,
            "thumb": s.data![x].media!.thumb,
            "thumbnail": s.data![x].media!.thumbnail,
            "isCoverLocal": false,
            "description": s.data![x].description,
            "isQueue": true,
          },
      ],
    };
    QueueModel queueModel = QueueModel.fromJson(json);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AlbumsDetailsPage(
          allAlbumData: null,
          allMusicData: data,
          queueModel: queueModel,
        ),
      ),
    );
  }

  void _onTag(String name) {
    _searchController.text = name;
    _searchText = name;
    setState(() {});
    _searchFocusNode!.unfocus();
  }
}
