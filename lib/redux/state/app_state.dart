import 'package:marvel_flutter_app/model/marvel_characters.dart';

class AppState {
  final List<CharacterResult> characters;

  AppState({this.characters});

  static AppState fromJson(dynamic json) {
    if (json != null) {
      final List<CharacterResult> characters = <CharacterResult>[];
      if (json['characters'] != null) {
        json['characters'].forEach((dynamic item) {
          characters.add(CharacterResult.fromJson(item));
        });
      }

      return AppState(characters: characters);
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> appStateData = Map<String, dynamic>();

    if (this.characters != null) {
      appStateData['characters'] =
          this.characters.map((CharacterResult cr) => cr.toJson()).toList();
    }

    return appStateData;
  }

  AppState.initialState()
      : characters = <CharacterResult>[];
}
