import 'package:flutter/material.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/config/repository/repo.dart';
import 'package:rally/models/allArtistsModel.dart';
import 'package:rally/pages/modules/artists/allContents/allContentsPage.dart';
import 'package:rally/providers/allArtistsProvider.dart';

import 'widget/allArtistsFullWidget.dart';
import 'widget/allArtistsWidget.dart';

class AllArtists extends StatefulWidget {
  final int? noOfContentDisplay;
  final bool? showNextSet;

  AllArtists({
    this.noOfContentDisplay,
    this.showNextSet = false,
  });

  @override
  State<AllArtists> createState() => _AllArtistsState();
}

class _AllArtistsState extends State<AllArtists> {
  PaginatedItemsResponse<AllArtistData>? _postsResponse;

  PaginatedItemsResponse<AllArtistData>? get postsResponse => _postsResponse;

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  Future<void> _loadFile() async {
    Repository repo = new Repository();
    repo.fetchAllArtists(true, 0);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: allArtistsModelStream,
      initialData: allArtistsModel ?? null,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.ok)
            return _mainContent(snapshot.data);
          else
            return allArtistsModel!.data == null
                ? emptyBoxLinear(context, msg: "${snapshot.data.msg}")
                : _mainContent(allArtistsModel!);
        } else if (snapshot.hasError) {
          return emptyBoxLinear(context, msg: "No data available");
        }
        return shimmerItem(useGrid: true);
      },
    );
  }

  Widget _mainContent(AllArtistsModel model) {
    _postsResponse = PaginatedItemsResponse<AllArtistData>(
      listItems: Iterable.castFrom(model.data!),
      // no support for pagination for current api
      paginationKey: null,
      idGetter: (post) => post.id.toString(),
    );
    return widget.noOfContentDisplay == -1000
        ? allArtistsFullWidget(
            context: context,
            model: model,
            onContent: (AllArtistData data) => _onArtist(data),
            fetchPageData: (bool) async {
              _postsResponse = PaginatedItemsResponse<AllArtistData>(
                listItems: Iterable.castFrom(model.data!),
                // no support for pagination for current api
                paginationKey: null,
                idGetter: (post) => post.id.toString(),
              );
              return _postsResponse;
            },
            response: postsResponse,
          )
        : allArtistsWidget(
            context: context,
            onArtist: (AllArtistData data) => _onArtist(data),
            model: model,
            onSeeAll: () => _onSeeAll(),
            showNextSet: widget.showNextSet,
          );
  }

  void _onSeeAll() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text("All Artists")),
          body: AllArtists(noOfContentDisplay: -1000),
        ),
      ),
    );
  }

  Future<void> _onArtist(AllArtistData data) async {
    await Navigator.of(context).push(
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
  }
}
