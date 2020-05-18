import 'package:flutter/material.dart';

class MarvelDetailUI extends StatelessWidget {
  final String name;
  final String description;
  final String imageURL;

  MarvelDetailUI(this.name, this.description, this.imageURL);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Hero(
              tag: '$name',
              child: Image.network(
                '$imageURL',
                width: double.infinity,
                height: 300,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(
                    description != '' ? description : 'Description not found',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
