import 'dart:async';
import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:marvel_flutter_app/characters.dart';
import 'package:crypto/crypto.dart';

Future<Characters> fetchData() async {
  final timestamp = new DateTime.now().millisecondsSinceEpoch;
  GlobalConfiguration configuration = new GlobalConfiguration();

  final publicKey = configuration.getString("publicKey");
  final privateKey = configuration.getString("privateKey");
  
  var bytes = utf8.encode("$timestamp$privateKey$publicKey");
  var hash = hex.encode(md5.convert(bytes).bytes);

  final response = await http
      .get('http://gateway.marvel.com/v1/public/characters?limit=100&ts=${timestamp}&apikey=${publicKey}&hash=${hash}');

  if (response.statusCode == 200) {
    return Characters.fromJson(json.decode(response.body));
  } else {
    throw Exception('Falló al cargar los datos.');
  }
}
