import 'package:article_api_app/news_article.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailsPage extends StatelessWidget {
  final NewsArticle article;

  const ArticleDetailsPage({required this.article});

  Widget keywordCard(List<dynamic> keywordsList, BuildContext context){

    List<Widget> cardList = [];
    for (var keyword in keywordsList.sublist(0,3)){
      cardList.add(
        Card(
          color: Colors.blue[200],
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(keyword),
          ),
          elevation: 5,
        )
      );
    }
    return Row(
      children: cardList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Article Details"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Author(s): ${article.author}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              'Publication date: ${article.pubDate.substring(0, 10)}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              child: Text(
                article.leadParagraph,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SingleChildScrollView(
              child: Text(
                article.snippet,
                style: TextStyle(fontSize: 16),
                ),
            ),
            SizedBox(height: 10),
            Text(
              'Article source: ${article.source}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            keywordCard(article.keywordsList, context),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                if (await canLaunch(article.webUrl)) {
                  await launch(article.webUrl);
                } else {
                  throw 'Could not launch ${article.webUrl}';
                }
              },
              child: Text(
                'Read more',
                style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}