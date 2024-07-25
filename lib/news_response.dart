import 'package:article_api_app/news_article.dart';

class NewsResponse {
  final String copyright;
  final List<NewsArticle> articles;

  NewsResponse({
    required this.copyright,
    required this.articles,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    var docs = json['response']['docs'] as List;
    List<NewsArticle> articleList = docs.map((article) => NewsArticle.fromJson(article)).toList();

    return NewsResponse(
      copyright: json['copyright'] as String,
      articles: articleList,
    );
  }
}
