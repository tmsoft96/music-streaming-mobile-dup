import 'package:rally/models/allRegularUserModel.dart';
import 'package:rxdart/rxdart.dart';

import '../config/repository/repo.dart';

class AllRegularUserBloc {
  Repository _repository = Repository();

  final _fetcher = PublishSubject<AllRegularUserModel>();

  Stream<AllRegularUserModel> get allRegularUser => _fetcher.stream;

  fetch() async {
    AllRegularUserModel response = await _repository.fetchAllRegularUser();
    _fetcher.sink.add(response);
  }

  dispose() {
    _fetcher.close();
  }
}

final allRegularUserBloc = AllRegularUserBloc();
