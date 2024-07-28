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
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(keyword),
          ),
        )
      );
    }
    return Row(
      children: cardList);
  }

  Future<void> launchUrL(String urlString) async {
  if (await canLaunchUrl(Uri.dataFromString(urlString))) { // Check if the URL can be launched
    await launchUrl(Uri.dataFromString(urlString));
  } else {
    throw 'Could not launch $urlString'; // throw could be used to handle erroneous situations
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Article Details"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Author(s): ${article.author}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              'Publication date: ${article.pubDate.substring(0, 10)}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              child: Text(
                article.leadParagraph,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            SingleChildScrollView(
              child: Text(
                article.snippet,
                style: const TextStyle(fontSize: 16),
                ),
            ),
            const SizedBox(height: 10),
            Text(
              'Article source: ${article.source}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            keywordCard(article.keywordsList, context),
            const SizedBox(height: 20),
            InkWell(
              onTap: (){launchUrL(article.webUrl);},
              child: const Text(
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