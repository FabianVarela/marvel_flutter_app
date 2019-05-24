import 'package:marvel_flutter_app/model/marvel_model.dart';
import 'package:marvel_flutter_app/client/marvel_client.dart';

class MarvelRepository {
  final client = MarvelClient();

  Future<MarvelModel> fetchHeroesData() {
    return client.fetchHeroesData();
  }
}
