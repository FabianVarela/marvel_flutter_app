import 'dart:async';

import 'package:marvel_flutter_app/model/marvel_model.dart';
import 'package:marvel_flutter_app/client/marvel_client.dart';

class MarvelBloc {
  final MarvelClient _marvelClient = MarvelClient();

  /// Init controllers
  final StreamController<MarvelModel> _dataStream =
      StreamController<MarvelModel>();
  final StreamController<bool> _isLoading = StreamController<bool>();

  /// Expose data from stream
  Stream<MarvelModel> get dataStream => _dataStream.stream;

  Stream<bool> get isLoading => _isLoading.stream;

  void fetchData() async {
    _isLoading.sink.add(true);

    try {
      final MarvelModel model = await _marvelClient.fetchHeroesData();

      if (model != null)
        _dataStream.sink.add(model);
      else
        _dataStream.sink.addError('No se encontraron registros');
    } catch (ex) {
      _dataStream.sink.addError(ex.toString());
    }

    _isLoading.sink.add(false);
  }

  void dispose() {
    _dataStream.close();
    _isLoading.close();
  }
}
