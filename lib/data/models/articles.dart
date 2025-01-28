import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'articles.g.dart';

@JsonSerializable()
class Articles extends Equatable {
  Articles({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  final String? status;
  static const String statusKey = "status";

  final int? totalResults;
  static const String totalResultsKey = "totalResults";

  final List<Article>? articles;
  static const String articlesKey = "articles";

  Articles copyWith({
    String? status,
    int? totalResults,
    List<Article>? articles,
  }) {
    return Articles(
      status: status ?? this.status,
      totalResults: totalResults ?? this.totalResults,
      articles: articles ?? this.articles,
    );
  }

  factory Articles.fromJson(Map<String, dynamic> json) => _$ArticlesFromJson(json);

  Map<String, dynamic> toJson() => _$ArticlesToJson(this);

  @override
  String toString() {
    return "$status, $totalResults, $articles, ";
  }

  @override
  List<Object?> get props => [
        status,
        totalResults,
        articles,
      ];
}

@JsonSerializable()
class Article extends Equatable {
  Article({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  final Source? source;
  static const String sourceKey = "source";

  final String? author;
  static const String authorKey = "author";

  final String? title;
  static const String titleKey = "title";

  final String? description;
  static const String descriptionKey = "description";

  final String? url;
  static const String urlKey = "url";

  final String? urlToImage;
  static const String urlToImageKey = "urlToImage";

  final DateTime? publishedAt;
  static const String publishedAtKey = "publishedAt";

  final String? content;
  static const String contentKey = "content";

  Article copyWith({
    Source? source,
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    DateTime? publishedAt,
    String? content,
  }) {
    return Article(
      source: source ?? this.source,
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
    );
  }

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  @override
  String toString() {
    return "$source, $author, $title, $description, $url, $urlToImage, $publishedAt, $content, ";
  }

  @override
  List<Object?> get props => [
        source,
        author,
        title,
        description,
        url,
        urlToImage,
        publishedAt,
        content,
      ];
}

@JsonSerializable()
class Source extends Equatable {
  Source({
    required this.id,
    required this.name,
  });

  final String? id;
  static const String idKey = "id";

  final String? name;
  static const String nameKey = "name";

  Source copyWith({
    String? id,
    String? name,
  }) {
    return Source(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);

  Map<String, dynamic> toJson() => _$SourceToJson(this);

  @override
  String toString() {
    return "$id, $name, ";
  }

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
