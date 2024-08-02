import 'package:rally/models/allPodcastModel.dart';
import 'package:rxdart/rxdart.dart';

import '../config/repository/repo.dart';

class AllPodcastBloc {
  Repository _repository = Repository();

  final _fetcher = PublishSubject<AllPodcastModel>();

  Stream<AllPodcastModel> get allPodcast => _fetcher.stream;

  Future<void> fetch() async {
    AllPodcastModel response = await _repository.fetchAllPodcast();
    _fetcher.sink.add(response);
  }

  dispose() {
    _fetcher.close();
  }
}

final allPodcastBloc = AllPodcastBloc();
