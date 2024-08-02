import 'package:rally/models/allFollowersModel.dart';
import 'package:rally/models/allGenreModel.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/models/allRegularUserModel.dart';
import 'package:rally/models/myPlaylistsModel.dart';
import 'package:rally/models/reasonsModel.dart';
import 'package:rally/providers/allAlbumHomepageProvider.dart';
import 'package:rally/providers/allArtistsProvider.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/allFollowersProvider.dart';
import 'package:rally/providers/allGenreProvider.dart';
import 'package:rally/providers/allMusicAllSongsProvider.dart';
import 'package:rally/providers/allMusicNewMusicProvider.dart';
import 'package:rally/providers/allMusicProvider.dart';
import 'package:rally/providers/allMusicTodaysHitsProvider.dart';
import 'package:rally/providers/allMusicTopPicksProvider.dart';
import 'package:rally/providers/allMusicTrendingProvider.dart';
import 'package:rally/providers/allPlaylistsProvider.dart';
import 'package:rally/providers/allPodcastProvider.dart';
import 'package:rally/providers/allRegularUserProvider.dart';
import 'package:rally/providers/bannersProvider.dart';
import 'package:rally/providers/myPlaylistsProvider.dart';
import 'package:rally/providers/reasonsProvider.dart';
import 'package:rally/providers/recentlyPlayedJointProvider.dart';
import 'package:rally/providers/recentlyPlayedSingleProvider.dart';

class Repository {
  AllGenreProvider _allGenreProvider = new AllGenreProvider();
  Future<AllGenreModel> fetchAllGenre() => _allGenreProvider.fetch();

  AllMusicProvider _allMusicProvider = new AllMusicProvider();
  Future<void> fetchAllMusic(bool isLoad, String? filterArtistId) =>
      _allMusicProvider.get(isLoad: isLoad, filterArtistId: filterArtistId);

  AllMusicNewMusicProvider _allMusicNewMusicModel =
      new AllMusicNewMusicProvider();
  Future<void> fetchAllNewMusic(bool isLoad) =>
      _allMusicNewMusicModel.get(isLoad: isLoad);

  AllMusicTodaysHitsProvider _allMusicTodaysHitsProvider =
      new AllMusicTodaysHitsProvider();
  Future<void> fetchAllMusicTodaysHits(bool isLoad) =>
      _allMusicTodaysHitsProvider.get(isLoad: isLoad);

  AllMusicTrendingProvider _allMusicTrendingProvider =
      new AllMusicTrendingProvider();
  Future<void> fetchAllMusicTrending(bool isLoad) =>
      _allMusicTrendingProvider.get(isLoad: isLoad);

  AllMusicTopPicksProvider _allMusicTopPicksProvider =
      new AllMusicTopPicksProvider();
  Future<void> fetchAllMusicTopPicks(bool isLoad) =>
      _allMusicTopPicksProvider.get(isLoad: isLoad);

  AllMusicAllSongsProvider _allMusicAllSongsProvider =
      new AllMusicAllSongsProvider();
  Future<void> fetchAllMusicAllSongs(bool isLoad) =>
      _allMusicAllSongsProvider.get(isLoad: isLoad);

  AllAlbumHomepageProvider _allAlbumProvider = new AllAlbumHomepageProvider();
  Future<void> fetchAllAlbum(bool isLoad) =>
      _allAlbumProvider.get(isLoad: isLoad);

  AllArtistsProvider _allArtistsProvider = new AllArtistsProvider();
  Future<void> fetchAllArtists(bool isLoad, int fetchArtistType) =>
      _allArtistsProvider.get(isLoad: isLoad, fetchArtistType: fetchArtistType);

  AllFollowersProvider _allFollowersProvider = new AllFollowersProvider();
  Future<AllFollowersModel> fetchAllFollowers(String userId,
          {bool isFetchFollowers: true}) =>
      _allFollowersProvider.fetch(userId, isFetchFollowers: isFetchFollowers);

  AllRegularUserProvider _allRegularUserProvider = new AllRegularUserProvider();
  Future<AllRegularUserModel> fetchAllRegularUser() =>
      _allRegularUserProvider.fetch();

  AllBannersProvider _allBannersProvider = new AllBannersProvider();
  Future<void> fetchAllBanner(bool isLoad) =>
      _allBannersProvider.get(isLoad: isLoad);

  AllPodcastProvider _allPodcastProvider = new AllPodcastProvider();
  Future<AllPodcastModel> fetchAllPodcast() => _allPodcastProvider.fetch();

  AllPlaylistsProvider _allPlaylistsProvider = new AllPlaylistsProvider();
  Future<void> fetchAllPlaylists(bool isLoad, String? userId, String? status) =>
      _allPlaylistsProvider.get(isLoad: isLoad, userId: userId, status: status);

  MyPlaylistsProvider _myPlaylistsProvider = new MyPlaylistsProvider();
  Future<MyPlaylistsModel> fetchMyPlaylists(String? userId, String? status) =>
      _myPlaylistsProvider.fetch(userId, status);

  ReasonsProvider _reasonsProvider = new ReasonsProvider();
  Future<ReasonsModel> fetchReasons() => _reasonsProvider.fetch();

  RecentlyPlayedSingleProvider _recentlyPlayedSingleProvider =
      new RecentlyPlayedSingleProvider();
  Future<void> fetchRecentlyPlayedSingle() =>
      _recentlyPlayedSingleProvider.get();

  RecentlyPlayedJointProvider _recentlyPlayedJointProvider =
      new RecentlyPlayedJointProvider();
  Future<void> fetchRecentlyPlayedJoint() => _recentlyPlayedJointProvider.get();

  AllDownloadProvider _allDownloadProvider = new AllDownloadProvider();
  Future<void> fetchAllDownload() => _allDownloadProvider.get();
}
