import 'package:flutter/material.dart';
import 'package:marvel_flutter_app/bloc/marvel_bloc.dart';
import 'package:marvel_flutter_app/model/marvel_model.dart';

class MarvelListUI extends StatefulWidget {
  @override
  _MarvelListUIState createState() => _MarvelListUIState();
}

class _MarvelListUIState extends State<MarvelListUI> {
  final bloc = MarvelBloc();

  @override
  void initState() {
    super.initState();
    bloc.fetchData();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Marvel Superheroes"),
      ),
      body: Center(
        child: StreamBuilder<MarvelModel>(
          stream: bloc.dataStream,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return setListData(snapshot.data.data.results);

            if (snapshot.hasError) return Center(child: Text(snapshot.error));

            return Text("Marvel Superheroes");
          },
        ),
      ),
    );
  }

  Widget setListData(List<Results> results) {
    return Container(
      child: ListView.builder(
        itemCount: results.length,
        padding: EdgeInsets.all(15),
        itemBuilder: (context, position) {
          var name = results[position].name;
          var imageName = results[position].thumbnail.path;
          var imageExtension = results[position].thumbnail.extension;

          return Column(
            children: <Widget>[
              Divider(height: 5),
              ListTile(
                title: Text(
                  "$name",
                  style: TextStyle(fontSize: 20, color: Colors.lightBlueAccent),
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.network(
                    "$imageName.$imageExtension",
                    width: 48,
                    height: 48,
                  ),
                ),
                onTap: () {},
              )
            ],
          );
        },
      ),
    );
  }

/*
  void _onTapItem(BuildContext context, Results results) {
    String desc = '';

    if (results.description.isEmpty) {
      desc = 'Sin descripción';
    } else {
      desc = results.description;
    }

    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(desc)));
  }
  */
}
