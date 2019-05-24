import 'dart:async';
import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart';
import 'package:marvel_flutter_app/model/marvel_model.dart';
import 'package:crypto/crypto.dart';

class MarvelClient {
  final client = Client();

  Future<MarvelModel> fetchHeroesData() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    GlobalConfiguration configuration = GlobalConfiguration();

    final publicKey = configuration.getString("publicKey");
    final privateKey = configuration.getString("privateKey");

    var bytes = utf8.encode("$timestamp$privateKey$publicKey");
    var hash = hex.encode(md5.convert(bytes).bytes);

    final response = await client.get(
        "http://gateway.marvel.com/v1/public/characters?limit=100&ts=$timestamp&apikey=$publicKey&hash=$hash");

    if (response.statusCode == 200) {
      return MarvelModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("An error has ocurred to fetch data");
    }
  }
}
