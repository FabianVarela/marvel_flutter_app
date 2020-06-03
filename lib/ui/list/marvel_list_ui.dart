import 'package:flutter/material.dart';
import 'package:marvel_flutter_app/bloc/marvel_character_bloc.dart';
import 'package:marvel_flutter_app/model/marvel_characters.dart';
import 'package:marvel_flutter_app/ui/detail/marvel_detail_ui.dart';
import 'package:marvel_flutter_app/ui/list/list_animation.dart';

class MarvelListUI extends StatefulWidget {
  @override
  _MarvelListUIState createState() => _MarvelListUIState();
}

class _MarvelListUIState extends State<MarvelListUI> {
  final TextEditingController _heroController = TextEditingController();
  final MarvelCharacterBloc _marvelCharacterBloc = MarvelCharacterBloc();

  @override
  void dispose() {
    _marvelCharacterBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
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
          ),
          Container(
            height: MediaQuery.of(context).size.height * .85,
            padding: EdgeInsets.only(top: 10),
            child: _setResultList(),
          ),
        ],
      ),
    );
  }

  Widget _setTextField() {
    return StreamBuilder<String>(
      stream: _marvelCharacterBloc.heroSearch,
      builder: (_, AsyncSnapshot<String> snapshot) {
        return TextField(
          controller: _heroController,
          onChanged: _marvelCharacterBloc.changeHero,
          decoration: InputDecoration(
            hintText: 'Marvel Superheroes',
            errorText: snapshot.hasError ? snapshot.error : null,
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide(color: Colors.grey.withOpacity(.6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        );
      },
    );
  }

  Widget _setSearchButton() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _marvelCharacterBloc.isValidData,
      builder: (_, AsyncSnapshot<bool> isValidSnapshot) {
        return RaisedButton(
          onPressed: isValidSnapshot.hasData && isValidSnapshot.data
              ? _marvelCharacterBloc.fetchCharacterData
              : null,
          shape: CircleBorder(),
          padding: EdgeInsets.all(14),
          child: Icon(Icons.search, color: Colors.white, size: 20),
        );
      },
    );
  }

  Widget _setResultList() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _marvelCharacterBloc.isLoading,
      builder: (_, AsyncSnapshot<bool> isLoadingSnapshot) {
        return StreamBuilder<MarvelCharacters>(
          stream: _marvelCharacterBloc.marvelCharacterStream,
          builder: (_, AsyncSnapshot<MarvelCharacters> charactersSnapshot) {
            if (isLoadingSnapshot.data) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (charactersSnapshot.connectionState == ConnectionState.active) {
              if (charactersSnapshot.hasData) {
                return MarvelListAnimation(
                  children: charactersSnapshot.data.data.results
                      .map(_setItem)
                      .toList(),
                );
              }

              if (charactersSnapshot.hasError) {
                return Center(
                  child: Text(
                    charactersSnapshot.error,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                );
              }
            }

            return Center(
              child: Text(
                'Search your favorite superhero',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
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
        tag: '${item.id}',
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
        builder: (_) => MarvelDetailUI(character: item),
      ),
    );
  }
}
