import 'package:flutter/material.dart';
import 'package:marvel_flutter_app/model/marvel_characters.dart';

class AddMarvelCharacterAction {
  final CharacterResult character;

  AddMarvelCharacterAction({@required this.character});

  Map<String, Map<String, dynamic>> toJson() {
    final Map<String, Map<String, dynamic>> json =
        Map<String, Map<String, dynamic>>();

    json['AddMarvelCharacterAction'] = this.character.toJson();

    return json;
  }
}

class RemoveMarvelCharacterAction {
  final CharacterResult character;

  RemoveMarvelCharacterAction({@required this.character});

  Map<String, Map<String, dynamic>> toJson() {
    final Map<String, Map<String, dynamic>> json =
        Map<String, Map<String, dynamic>>();

    json['RemoveMarvelCharacterAction'] = this.character.toJson();

    return json;
  }
}
