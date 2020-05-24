import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:marvel_flutter_app/bloc/marvel_comic_bloc.dart';
import 'package:marvel_flutter_app/model/marvel_comic.dart';
import 'package:marvel_flutter_app/ui/detail/comic_list_item.dart';

class MarvelDetailUI extends StatefulWidget {
  MarvelDetailUI({
    this.id,
    this.name,
    this.description,
    this.imageURL,
  });

  final int id;
  final String name;
  final String description;
  final String imageURL;

  @override
  _MarvelDetailUIState createState() => _MarvelDetailUIState();
}

class _MarvelDetailUIState extends State<MarvelDetailUI>
    with TickerProviderStateMixin {
  final MarvelComicBloc _marvelComicBloc = MarvelComicBloc();

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future<void>.delayed(Duration(milliseconds: 500),
        () => _marvelComicBloc.fetchComicData(widget.id.toString()));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// TODO: Adding favorite with redux

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Hero(
                tag: '${widget.id}',
                child: Image.network(
                  '${widget.imageURL}',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .65,
                child: _setBody(),
              ),
            ],
          ),
          SafeArea(
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
                    widget.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _marvelComicBloc.addToFavourites(''),
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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
                child: Text('Loading ${widget.name}\'s comics'),
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
          height: MediaQuery.of(context).size.height * .56,
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              if (widget.description.trim().isNotEmpty) _setTextDescription(),
              if (widget.description.trim().isEmpty) _setEmptyDescriptionText(),
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
        'Comics of ${widget.name} not found',
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
          widget.description,
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
