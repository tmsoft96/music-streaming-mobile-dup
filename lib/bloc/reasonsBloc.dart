import 'package:rally/models/reasonsModel.dart';
import 'package:rxdart/rxdart.dart';

import '../config/repository/repo.dart';

class ReasonsBloc {
  Repository _repository = Repository();

  final _fetcher = PublishSubject<ReasonsModel>();

  Stream<ReasonsModel> get reasons => _fetcher.stream;

  Future<void> fetch() async {
    ReasonsModel response = await _repository.fetchReasons();
    _fetcher.sink.add(response);
  }

  dispose() {
    _fetcher.close();
  }
}

final reasonsBloc = ReasonsBloc();
