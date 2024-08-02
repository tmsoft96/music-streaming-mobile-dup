import 'package:rally/models/allGenreModel.dart';
import 'package:rxdart/rxdart.dart';

import '../config/repository/repo.dart';

class AllGenreBloc {
  Repository _repository = Repository();

  final _fetcher = PublishSubject<AllGenreModel>();

  Stream<AllGenreModel> get genre => _fetcher.stream;

  fetch() async {
    AllGenreModel response = await _repository.fetchAllGenre();
    _fetcher.sink.add(response);
  }

  dispose() {
    _fetcher.close();
  }
}

final allGenreBloc = AllGenreBloc();
