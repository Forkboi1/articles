class NewsArticle {
  final String abstract;
  final String webUrl;
  final String snippet;
  final String leadParagraph;
  final String source;
  final String title;
  final List keywordsList;
  final String pubDate;
  final String author;

  NewsArticle({
    required this.abstract,
    required this.webUrl,
    required this.snippet,
    required this.leadParagraph,
    required this.source,
    required this.title,
    required this.keywordsList,
    required this.pubDate,
    required this.author,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    var keywords = json['keywords'] as List;
    List keywordsList = keywords.map((keyword) => keyword['value']).toList();
    return NewsArticle(
      abstract: json['abstract'] as String,
      webUrl: json['web_url'] as String,
      snippet: json['snippet'] as String,
      leadParagraph: json['lead_paragraph'] as String,
      source: json['source'] as String,
      title: json['headline']['main'] as String,
      keywordsList: keywordsList,
      pubDate: json['pub_date'],
      author: json['byline']['original'],

    );
  }
}
