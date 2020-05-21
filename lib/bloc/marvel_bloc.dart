import 'dart:async';

import 'package:marvel_flutter_app/model/marvel_model.dart';
import 'package:marvel_flutter_app/client/marvel_client.dart';
import 'package:rxdart/rxdart.dart';

class MarvelBloc {
  final MarvelClient _marvelClient = MarvelClient();

  /// Init controllers
  final BehaviorSubject<String> _heroSearch = BehaviorSubject<String>();

  final PublishSubject<MarvelModel> _dataStream = PublishSubject<MarvelModel>();

  final PublishSubject<bool> _isLoading = PublishSubject<bool>();

  /// Validator
  final StreamTransformer<String, String> validateEmpty =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (String text, EventSink<String> sink) {
    if (text.isNotEmpty) {
      sink.add(text);
    } else {
      sink.addError('Enter a valid text');
    }
  });

  /// Expose data from stream
  Stream<String> get heroSearch => _heroSearch.stream.transform(validateEmpty);

  Stream<bool> get isValidData => heroSearch.map((String value) => true);

  Stream<MarvelModel> get dataStream => _dataStream.stream;

  Stream<bool> get isLoading => _isLoading.stream;

  /// Functions
  Function(String) get changeHero => _heroSearch.sink.add;

  void fetchData() async {
    _isLoading.sink.add(true);

    try {
      final MarvelModel model =
          await _marvelClient.fetchHeroesData(_heroSearch.value);

      if (model != null && model.data.results.isNotEmpty)
        _dataStream.sink.add(model);
      else
        _dataStream.sink.addError('No data found');
    } catch (ex) {
      _dataStream.sink.addError(ex.toString());
    }

    _isLoading.sink.add(false);
  }

  void dispose() {
    _heroSearch.close();
    _dataStream.close();
    _isLoading.close();
  }
}
