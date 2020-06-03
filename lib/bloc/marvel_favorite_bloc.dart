import 'package:marvel_flutter_app/model/marvel_characters.dart';
import 'package:marvel_flutter_app/redux/action/marvel_action.dart';
import 'package:marvel_flutter_app/redux/state/app_state.dart';
import 'package:redux/redux.dart';

class MarvelFavoriteBloc {
  final Store<AppState> _store;

  MarvelFavoriteBloc(this._store);

  List<CharacterResult> get characterStore => _store.state.characters;

  bool isFavorite(int id) {
    if (_store.state.characters.isNotEmpty) {
      final CharacterResult result = _store.state.characters.firstWhere(
        (CharacterResult res) => res.id == id,
        orElse: () => null,
      );

      if (result != null) {
        return true;
      }
    }

    return false;
  }

  void addToFavorites(CharacterResult character) =>
      _store.dispatch(AddMarvelCharacterAction(character: character));

  void removeToFavorites(CharacterResult character) =>
      _store.dispatch(RemoveMarvelCharacterAction(character: character));
}
