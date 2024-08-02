import 'package:rally/models/myPlaylistsModel.dart';
import 'package:rxdart/rxdart.dart';

import '../config/repository/repo.dart';

class MyPlaylistsBloc {
  Repository _repository = Repository();

  final _fetcher = PublishSubject<MyPlaylistsModel>();

  Stream<MyPlaylistsModel> get allPlaylists => _fetcher.stream;

  Future<void> fetch(String? userId, String? status) async {
    MyPlaylistsModel response = await _repository.fetchMyPlaylists(
      userId,
      status,
    );
    _fetcher.sink.add(response);
  }

  dispose() {
    _fetcher.close();
  }
}

final myPlaylistsBloc = MyPlaylistsBloc();
