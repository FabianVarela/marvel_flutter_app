class MarvelCharacters {
  final Data data;

  MarvelCharacters({this.data});

  factory MarvelCharacters.fromJson(Map<String, dynamic> json) =>
      MarvelCharacters(data: Data.fromJson(json['data']));
}

class Data {
  final List<Results> results;

  Data({this.results});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        results: (json['results'] as List<dynamic>)
            .map((dynamic item) => Results.fromJson(item))
            .toList(),
      );
}

class Results {
  final int id;
  final String name;
  final String description;
  final Thumbnail thumbnail;
  final String resourceURI;

  Results({
    this.id,
    this.name,
    this.description,
    this.thumbnail,
    this.resourceURI,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        thumbnail: Thumbnail.fromJson(json['thumbnail']),
        resourceURI: json['resourceURI'],
      );
}

class Thumbnail {
  final String path;
  final String extension;

  Thumbnail({this.path, this.extension});

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        path: json['path'],
        extension: json['extension'],
      );
}
