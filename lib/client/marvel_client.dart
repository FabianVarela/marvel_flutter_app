import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:http/http.dart';
import 'package:crypto/crypto.dart';

import 'package:marvel_flutter_app/model/marvel_characters.dart';
import 'package:marvel_flutter_app/model/marvel_comic.dart';

class MarvelClient {
  final Client _client = Client();

  final String _uri = 'gateway.marvel.com';
  final String _publicKey = '83befde037c95e62a7aeaf43d5a4b59b';
  final String _privateKey = 'dbee5457fd20d705691d8bae586229966cbbc759';

  Future<MarvelCharacters> fetchHeroesData(String text) async {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final Uri uri = Uri.https(
      _uri,
      '/v1/public/characters',
      <String, String>{
        'nameStartsWith': text,
        'limit': 100.toString(),
        'ts': '$timestamp',
        'apikey': _publicKey,
        'hash': _getHash(timestamp),
      },
    );

    final Response response = await _client.get(uri);

    if (response.statusCode == 200) {
      return MarvelCharacters.fromJson(json.decode(response.body));
    } else {
      throw Exception('An error has ocurred to fetch characters');
    }
  }

  Future<MarvelComic> fetchComicData(String character) async {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final Uri uri = Uri.https(
      _uri,
      '/v1/public/characters/$character/comics',
      <String, String>{
        'ts': '$timestamp',
        'apikey': _publicKey,
        'hash': _getHash(timestamp),
      },
    );

    final Response response = await _client.get(uri);

    if (response.statusCode == 200) {
      return MarvelComic.fromJson(json.decode(response.body));
    } else {
      throw Exception('An error has occurred to fetch comic');
    }
  }

  String _getHash(int timestamp) {
    final Uint8List bytes = utf8.encode('$timestamp$_privateKey$_publicKey');
    return hex.encode(md5.convert(bytes).bytes);
  }
}
