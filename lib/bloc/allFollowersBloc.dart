import 'package:rally/models/allFollowersModel.dart';
import 'package:rxdart/rxdart.dart';

import '../config/repository/repo.dart';

class AllFollowersBloc {
  Repository _repository = Repository();

  final _fetcher = PublishSubject<AllFollowersModel>();

  Stream<AllFollowersModel> get allFollow => _fetcher.stream;

  fetch(String userId, {bool isFetchFollowers: true}) async {
    AllFollowersModel response = await _repository.fetchAllFollowers(
      userId,
      isFetchFollowers: isFetchFollowers,
    );
    _fetcher.sink.add(response);
  }

  dispose() {
    _fetcher.close();
  }
}

final allFollowersBloc = AllFollowersBloc();
