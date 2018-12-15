class Characters {
  final Data data;

  Characters({this.data});

  factory Characters.fromJson(Map<String, dynamic> json) {
    return Characters(data: Data.fromJson(json['data']));
  }
}

class Data {
  final List<Results> results;

  Data({this.results});

  factory Data.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<Results> results = list.map((item) => Results.fromJson(item)).toList();
    
    return Data(results: results);
  }
}

class Results {
  final int id;
  final String name;
  final String description;
  final Thumbnail thumbnail;
  final String resourceURI;

  Results(
      {this.id, this.name, this.description, this.thumbnail, this.resourceURI});

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        thumbnail: Thumbnail.fromJson(json['thumbnail']),
        resourceURI: json['resourceURI']);
  }
}

class Thumbnail {
  final String path;
  final String extension;

  Thumbnail({this.path, this.extension});

  factory Thumbnail.fromJson(Map<String, dynamic> json) {
    return Thumbnail(path: json['path'], extension: json['extension']);
  }
}
