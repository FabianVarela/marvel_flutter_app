import 'package:flutter/material.dart';
import 'package:marvel_flutter_app/ui/marvel_list_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Marvel Superheroes',
      home: MarvelListUI(),
    );
  }
}
