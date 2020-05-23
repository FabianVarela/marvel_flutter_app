class MarvelComic {
  MarvelComic({this.data});

  final ComicData data;

  MarvelComic.fromJson(Map<String, dynamic> json)
      : data = ComicData.fromJson(json['data']);
}

class ComicData {
  ComicData({this.total, this.results});

  final int total;
  final List<ComicResult> results;

  ComicData.fromJson(Map<String, dynamic> json)
      : total = json['total'],
        results = (json['results'] as List<dynamic>)
            .map((dynamic item) => ComicResult.fromJson(item))
            .toList();
}

class ComicResult {
  ComicResult(
    this.id,
    this.digitalId,
    this.title,
    this.description,
    this.format,
    this.pages,
    this.prices,
    this.mainImage,
    this.secondImages,
    this.creators,
  );

  final int id;
  final int digitalId;
  final String title;
  final String description;
  final String format;
  final int pages;
  final List<ComicPrice> prices;
  final ComicThumbnail mainImage;
  final List<ComicThumbnail> secondImages;
  final List<ComicCreators> creators;

  ComicResult.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        digitalId = json['digitalId'],
        title = json['title'],
        description = json['description'],
        format = json['format'],
        pages = json['pageCount'],
        prices = (json['prices'] as List<dynamic>)
            .map((dynamic item) => ComicPrice.fromJson(item))
            .toList(),
        mainImage = ComicThumbnail.fromJson(json['thumbnail']),
        secondImages = (json['images'] as List<dynamic>)
            .map((dynamic item) => ComicThumbnail.fromJson(item))
            .toList(),
        creators = (json['creators']['items'] as List<dynamic>)
            .map((dynamic item) => ComicCreators.fromJson(item))
            .toList();
}

enum PriceType {
  PRINT,
  DIGITAL,
  NONE,
}

class ComicPrice {
  ComicPrice(this.type, this.price);

  final PriceType type;
  final double price;

  ComicPrice.fromJson(Map<String, dynamic> json)
      : type = json['type'] != null
            ? PriceType.NONE
            : json['type'] == 'printPrice'
                ? PriceType.PRINT
                : PriceType.DIGITAL,
        price = json['price'];
}

class ComicThumbnail {
  ComicThumbnail(this.path, this.extension);

  final String path;
  final String extension;

  ComicThumbnail.fromJson(Map<String, dynamic> json)
      : path = json['path'],
        extension = json['extension'];
}

class ComicCreators {
  ComicCreators(this.name, this.role);

  final String name;
  final String role;

  ComicCreators.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        role = json['role'];
}
