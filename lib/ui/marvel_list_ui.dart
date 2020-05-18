import 'package:flutter/material.dart';
import 'package:marvel_flutter_app/bloc/marvel_bloc.dart';
import 'package:marvel_flutter_app/model/marvel_model.dart';
import 'package:marvel_flutter_app/ui/marvel_detail_ui.dart';

class MarvelListUI extends StatefulWidget {
  @override
  _MarvelListUIState createState() => _MarvelListUIState();
}

class _MarvelListUIState extends State<MarvelListUI> {
  final MarvelBloc bloc = MarvelBloc();

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
        title: Text('Marvel Superheroes'),
      ),
      body: Center(
        child: StreamBuilder<MarvelModel>(
          stream: bloc.dataStream,
          builder: (_, AsyncSnapshot<MarvelModel> snapshot) {
            if (snapshot.hasData)
              return setListData(snapshot.data.data.results);

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error));
            }

            return Text('Marvel Superheroes');
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
        itemBuilder: (_, int index) {
          final Results item = results[index];
          final String imageUrl =
              '${item.thumbnail.path}.${item.thumbnail.extension}';
          return Column(
            children: <Widget>[
              Divider(height: 5),
              ListTile(
                title: Text(
                  '${item.name}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                leading: Hero(
                  tag: '${item.name}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.network(
                      '$imageUrl',
                      width: 48,
                      height: 48,
                    ),
                  ),
                ),
                onTap: () => _redirectToDetail(
                  item.name,
                  item.description,
                  '$imageUrl',
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void _redirectToDetail(String name, String description, String image) {
    Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder: (_) => MarvelDetailUI(name, description, image),
      ),
    );
  }
}
