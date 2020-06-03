import 'package:marvel_flutter_app/client/marvel_client.dart';
import 'package:marvel_flutter_app/model/marvel_comic.dart';
import 'package:rxdart/rxdart.dart';

class MarvelComicBloc {
  final MarvelClient _marvelClient = MarvelClient();

  /// Init controllers
  final PublishSubject<MarvelComic> _marvelComicSubject =
      PublishSubject<MarvelComic>();

  final PublishSubject<bool> _isLoading = PublishSubject<bool>();

  /// Expose data from stream
  Stream<MarvelComic> get marvelComicSubject => _marvelComicSubject.stream;

  Stream<bool> get isLoading => _isLoading.stream;

  void fetchComicData(String character) async {
    _isLoading.sink.add(true);

    try {
      final MarvelComic model = await _marvelClient.fetchComicData(character);

      if (model != null && model.data.results.isNotEmpty)
        _marvelComicSubject.sink.add(model);
      else
        _marvelComicSubject.sink.addError('No comics found');
    } catch (ex) {
      _marvelComicSubject.sink.addError(ex.toString());
    }

    _isLoading.sink.add(false);
  }

  void dispose() {
    _marvelComicSubject.close();
    _isLoading.close();
  }
}
