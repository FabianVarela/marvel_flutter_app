class MarvelCharacters {
  MarvelCharacters({this.data});

  final CharacterData data;

  MarvelCharacters.fromJson(Map<String, dynamic> json)
      : data = CharacterData.fromJson(json['data']);
}

class CharacterData {
  CharacterData({this.results});

  final List<CharacterResult> results;

  CharacterData.fromJson(Map<String, dynamic> json)
      : results = (json['results'] as List<dynamic>)
            .map((dynamic item) => CharacterResult.fromJson(item))
            .toList();
}

class CharacterResult {
  CharacterResult({
    this.id,
    this.name,
    this.description,
    this.thumbnail,
    this.resourceURI,
  });

  final int id;
  final String name;
  final String description;
  final CharacterThumbnail thumbnail;
  final String resourceURI;

  CharacterResult.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        thumbnail = CharacterThumbnail.fromJson(json['thumbnail']),
        resourceURI = json['resourceURI'];
}

class CharacterThumbnail {
  CharacterThumbnail({this.path, this.extension});

  final String path;
  final String extension;

  CharacterThumbnail.fromJson(Map<String, dynamic> json)
      : path = json['path'],
        extension = json['extension'];
}
