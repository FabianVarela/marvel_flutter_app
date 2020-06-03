import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:marvel_flutter_app/bloc/marvel_comic_bloc.dart';
import 'package:marvel_flutter_app/bloc/marvel_favorite_bloc.dart';
import 'package:marvel_flutter_app/model/marvel_characters.dart';
import 'package:marvel_flutter_app/model/marvel_comic.dart';
import 'package:marvel_flutter_app/redux/state/app_state.dart';
import 'package:marvel_flutter_app/ui/detail/comic_list_item.dart';
import 'package:redux/redux.dart';

class MarvelDetailUI extends StatefulWidget {
  MarvelDetailUI({this.character});

  final CharacterResult character;

  @override
  _MarvelDetailUIState createState() => _MarvelDetailUIState();
}

class _MarvelDetailUIState extends State<MarvelDetailUI>
    with TickerProviderStateMixin {
  MarvelComicBloc _marvelComicBloc = MarvelComicBloc();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _marvelComicBloc.fetchComicData(widget.character.id.toString());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _marvelComicBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String imagePath = widget.character.thumbnail.path;
    final String imageExtension = widget.character.thumbnail.extension;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Hero(
                tag: '${widget.character.id}',
                child: Image.network(
                  '$imagePath.$imageExtension',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .62,
                child: _setBody(),
              ),
            ],
          ),
          _setHeader(),
        ],
      ),
    );
  }

  Widget _setHeader() {
    return SafeArea(
      bottom: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 30,
            ),
          ),
          Expanded(
            child: Text(
              widget.character.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          _setFavoriteIconButton()
        ],
      ),
    );
  }

  Widget _setFavoriteIconButton() {
    return StoreConnector<AppState, MarvelFavoriteBloc>(
      distinct: true,
      converter: (Store<AppState> store) => MarvelFavoriteBloc(store),
      builder: (_, MarvelFavoriteBloc bloc) {
        final bool isFavorite = bloc.isFavorite(widget.character.id);

        return IconButton(
          onPressed: () {
            if (isFavorite) {
              bloc.removeToFavorites(widget.character);
            } else {
              bloc.addToFavorites(widget.character);
            }
          },
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.white,
            size: 30,
          ),
        );
      },
    );
  }

  Widget _setBody() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _marvelComicBloc.isLoading,
      builder: (_, AsyncSnapshot<bool> isLoadingSnapshot) {
        return StreamBuilder<MarvelComic>(
          stream: _marvelComicBloc.marvelComicSubject,
          builder: (_, AsyncSnapshot<MarvelComic> comicSnapshot) {
            if (isLoadingSnapshot.data) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (comicSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Loading ${widget.character.name}\'s comics'),
              );
            }

            return _setTab(comicSnapshot);
          },
        );
      },
    );
  }

  Widget _setTab(AsyncSnapshot<MarvelComic> comicSnapshot) {
    return Column(
      children: <Widget>[
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.blueGrey,
          labelColor: Colors.blueGrey,
          labelPadding: EdgeInsets.symmetric(vertical: 10),
          labelStyle: TextStyle(fontSize: 16),
          indicatorWeight: 4,
          tabs: <Widget>[
            Tab(
              icon: Column(
                children: <Widget>[
                  Icon(Icons.account_circle),
                  Text('Description'),
                ],
              ),
            ),
            Tab(
              icon: Column(
                children: <Widget>[
                  Icon(Icons.library_books),
                  Text('Comics'),
                ],
              ),
            ),
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height * .53,
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              if (widget.character.description.trim().isNotEmpty)
                _setTextDescription(),
              if (widget.character.description.trim().isEmpty)
                _setEmptyDescriptionText(),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 16,
                ),
                child: _setSecondTab(comicSnapshot),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _setSecondTab(AsyncSnapshot<MarvelComic> comicSnapshot) {
    if (comicSnapshot.hasData) {
      final List<ComicResult> results = comicSnapshot.data.data.results;

      return PageView.builder(
        itemCount: results.length,
        itemBuilder: (_, int index) => ComicListItem(comic: results[index]),
      );
    }

    if (comicSnapshot.hasError) {
      return Center(
        child: Text(
          comicSnapshot.error,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w300,
          ),
        ),
      );
    }

    return Center(
      child: Text(
        'Comics of ${widget.character.name} not found',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _setTextDescription() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        child: HtmlWidget(
          widget.character.description,
          textStyle: TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  Widget _setEmptyDescriptionText() {
    return Center(
      child: Text(
        'Description not found',
        style: TextStyle(
          fontSize: 25,
          color: Colors.black,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
