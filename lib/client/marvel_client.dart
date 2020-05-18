import 'dart:async';
import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:http/http.dart';
import 'package:marvel_flutter_app/model/marvel_model.dart';
import 'package:crypto/crypto.dart';

class MarvelClient {
  final Client _client = Client();

  static const String _uri = 'gateway.marvel.com';
  static const String _publicKey = '83befde037c95e62a7aeaf43d5a4b59b';
  static const String _privateKey = 'dbee5457fd20d705691d8bae586229966cbbc759';

  Future<MarvelModel> fetchHeroesData() async {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    final List<int> bytes = utf8.encode('$timestamp$_privateKey$_publicKey');
    final String hash = hex.encode(md5.convert(bytes).bytes);

    final Uri uri = Uri(
      scheme: 'http',
      host: _uri,
      path: '/v1/public/characters',
      queryParameters: <String, dynamic>{
        'limit': 100,
        'ts': timestamp,
        'apiKey': _publicKey,
        'hash': hash,
      },
    );

    final Response response = await _client.get(uri);

    if (response.statusCode == 200) {
      return MarvelModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('An error has ocurred to fetch data');
    }
  }
}
