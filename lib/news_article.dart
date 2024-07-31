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
      abstract: json['abstract']  ?? "",
      webUrl: json['web_url'] ?? "",
      snippet: json['snippet'] ?? "",
      leadParagraph: json['lead_paragraph'] ?? "",
      source: json['source'] ?? "",
      title: json['headline']['main'] ?? "",
      keywordsList: keywordsList,
      pubDate: json['pub_date']  ?? "",
      author: json['byline']['original'] ?? "",

    );
  }
}
