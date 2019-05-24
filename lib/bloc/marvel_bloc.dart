import 'dart:async';

import 'package:marvel_flutter_app/model/marvel_model.dart';
import 'package:marvel_flutter_app/repository/marvel_repository.dart';

class MarvelBloc {
  final _repository = MarvelRepository();

  /// Init controllers
  final _dataStream = StreamController<MarvelModel>();
  final _isLoading = StreamController<bool>();

  /// Expose data from stream
  Stream<MarvelModel> get dataStream => _dataStream.stream;

  Stream<bool> get isLoading => _isLoading.stream;

  /// Functions
  void fetchData() async {
    _isLoading.sink.add(true);

    try {
      var data = await _repository.fetchHeroesData();

      if (data != null)
        _dataStream.sink.add(data);
      else
        _dataStream.sink.addError("No se encontraron registros");
    } catch (ex) {
      _dataStream.sink.addError(ex);
    }

    _isLoading.sink.add(false);
  }

  void dispose() {
    _dataStream.close();
    _isLoading.close();
  }
}
