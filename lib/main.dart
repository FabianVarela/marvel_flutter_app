import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:marvel_flutter_app/ui/marvel_list_ui.dart';

void main() async {
  await GlobalConfiguration().loadFromAsset("app_settings");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Marvel Superheroes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MarvelListUI(),
    );
  }
}
