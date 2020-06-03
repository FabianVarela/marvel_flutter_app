import 'package:marvel_flutter_app/model/marvel_characters.dart';
import 'package:marvel_flutter_app/redux/action/marvel_action.dart';
import 'package:redux/redux.dart';

List<CharacterResult> addCharactersReducer(
    List<CharacterResult> state, AddMarvelCharacterAction action) {
  final CharacterResult item = state.firstWhere(
    (CharacterResult element) => element.id == action.character.id,
    orElse: () => null,
  );

  if (item == null) {
    state.add(action.character);
  }

  return state;
}

List<CharacterResult> removeCharactersReducer(
    List<CharacterResult> state, RemoveMarvelCharacterAction action) {
  final CharacterResult item = state.firstWhere(
    (CharacterResult element) => element.id == action.character.id,
    orElse: () => null,
  );

  if (item != null) {
    state.remove(action.character);
  }

  return state;
}

/// Combine Reducers

final Reducer<List<CharacterResult>> charactersReducer =
    combineReducers<List<CharacterResult>>(
  <Reducer<List<CharacterResult>>>[
    TypedReducer<List<CharacterResult>, AddMarvelCharacterAction>(
      addCharactersReducer,
    ),
    TypedReducer<List<CharacterResult>, RemoveMarvelCharacterAction>(
      removeCharactersReducer,
    ),
  ],
);
