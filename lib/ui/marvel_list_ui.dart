import 'package:flutter/material.dart';
import 'package:marvel_flutter_app/bloc/marvel_bloc.dart';
import 'package:marvel_flutter_app/model/marvel_characters.dart';
import 'package:marvel_flutter_app/ui/marvel_detail_ui.dart';

class MarvelListUI extends StatefulWidget {
  @override
  _MarvelListUIState createState() => _MarvelListUIState();
}

class _MarvelListUIState extends State<MarvelListUI> {
  final TextEditingController _heroController = TextEditingController();
  final MarvelBloc _marvelBloc = MarvelBloc();

  @override
  void dispose() {
    _marvelBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Marvel Superheroes'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: _setTextField(),
                ),
                Expanded(
                  flex: 1,
                  child: _setSearchButton(),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .8,
            child: _setResultList(),
          ),
        ],
      ),
    );
  }

  Widget _setTextField() {
    return StreamBuilder<String>(
      stream: _marvelBloc.heroSearch,
      builder: (_, AsyncSnapshot<String> snapshot) {
        return TextField(
          controller: _heroController,
          onChanged: _marvelBloc.changeHero,
        );
      },
    );
  }

  Widget _setSearchButton() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _marvelBloc.isValidData,
      builder: (_, AsyncSnapshot<bool> isValidSnapshot) {
        return RaisedButton(
          onPressed: isValidSnapshot.hasData && isValidSnapshot.data
              ? _marvelBloc.fetchData
              : null,
          shape: CircleBorder(),
          padding: EdgeInsets.all(15),
          child: Icon(Icons.search, color: Colors.white, size: 20),
        );
      },
    );
  }

  Widget _setResultList() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _marvelBloc.isLoading,
      builder: (_, AsyncSnapshot<bool> isLoadingSnapshot) {
        return StreamBuilder<MarvelCharacters>(
          stream: _marvelBloc.dataStream,
          builder: (_, AsyncSnapshot<MarvelCharacters> snapshot) {
            if (isLoadingSnapshot.data) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return MarvelListAnimation(
                  children: snapshot.data.data.results.map(_setItem).toList(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error),
                );
              }
            }

            return Center(
              child: Text('Search your favorite superhero'),
            );
          },
        );
      },
    );
  }

  Widget _setItem(CharacterResult item) {
    final String image = '${item.thumbnail.path}.${item.thumbnail.extension}';

    return ListTile(
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
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            '$image',
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        ),
      ),
      onTap: () => _redirectToDetail(item, image),
    );
  }

  void _redirectToDetail(CharacterResult item, String image) {
    Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder: (_) => MarvelDetailUI(item.name, item.description, image),
      ),
    );
  }
}

class MarvelListAnimation extends StatelessWidget {
  MarvelListAnimation({@required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: children.length,
      itemBuilder: (_, int index) {
        return ListItem(
          child: children[index],
          position: index,
          duration: Duration(milliseconds: 300 + index),
          // set duration
        );
      },
    );
  }
}

class ListItem extends StatefulWidget {
  ListItem({this.position, this.child, this.duration});

  final int position;
  final Widget child;
  final Duration duration;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset.zero)
        .animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    Future<void>.delayed(widget.duration, () => _controller.forward());

    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}
