import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:marvel_flutter_app/model/marvel_comic.dart';

class ComicListItem extends StatelessWidget {
  ComicListItem({@required this.comic});

  final ComicResult comic;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: _setComicImage(),
                  ),
                  _setComicDetails(),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: _setComicDescription(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: _setComicCreators(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _setComicImage() {
    return Container(
      width: 120,
      height: 200,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: Offset(0, 10),
          )
        ],
        image: DecorationImage(
          image: NetworkImage(
            '${comic.mainImage.path}.${comic.mainImage.extension}',
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _setComicDetails() {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              comic.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _setRowText('Book type: ', comic.format),
          _setRowText('Ref: ', comic.id.toString()),
          _setRowText('Pages: ', comic.pages.toString()),
          _setPriceButtons(),
        ],
      ),
    );
  }

  Widget _setComicDescription() {
    return _setColumnSection(
      'Resume',
      Padding(
        padding: EdgeInsets.only(top: 5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: HtmlWidget(
            comic.description ?? 'No description',
            enableCaching: false,
            bodyPadding: EdgeInsets.zero,
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }

  Widget _setComicCreators() {
    return _setColumnSection(
      'Creators',
      Container(
        height: 90,
        margin: EdgeInsets.symmetric(vertical: 10),
        child: comic.creators.isEmpty ? _setEmptyCreators() : _setCreatorList(),
      ),
    );
  }

  Widget _setEmptyCreators() {
    return Text(
      'No creators found',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _setCreatorList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      itemCount: comic.creators.length,
      itemBuilder: (_, int index) {
        final ComicCreators item = comic.creators[index];

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.account_circle,
                color: Colors.grey,
                size: 45,
              ),
              HtmlWidget(
                item.name,
                bodyPadding: EdgeInsets.zero,
                enableCaching: false,
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                item.role,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _setRowText(String title, String message,
      {Color color = Colors.black}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 14, color: color),
          children: <TextSpan>[
            TextSpan(
              text: title,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: message,
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }

  Widget _setPriceButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List<Widget>.generate(comic.prices.length, (int index) {
        final ComicPrice item = comic.prices[index];
        final double price = item.price;
        final String type = _printType(item.type);

        if (price > 0 && type != 'None') {
          return RaisedButton(
            color: Colors.blueGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: _setRowText('$type: ', '\$$price', color: Colors.white),
            onPressed: () {},
          );
        }

        return Container();
      }),
    );
  }

  Widget _setColumnSection(String title, Widget child) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        child,
      ],
    );
  }

  String _printType(PriceType type) {
    switch (type) {
      case PriceType.PRINT:
        return 'Print';
      case PriceType.DIGITAL:
        return 'Digital';
      case PriceType.NONE:
      default:
        return 'None';
    }
  }
}
