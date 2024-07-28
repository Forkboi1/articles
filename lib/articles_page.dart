import 'package:article_api_app/news_article.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'text.dart';


import 'news_response.dart';

class ArticlesPage extends StatefulWidget{
  final Function(int, NewsArticle) onArticleTap;

  const ArticlesPage({super.key, required this.onArticleTap});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final String apiKey = "dAW9ddalQtqRLpyuqJLdKlGVCpK2YXsP";
  List<NewsArticle> articleList = [];

  @override
  void initState(){
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async{
    final url = "https://api.nytimes.com/svc/search/v2/articlesearch.json?api-key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200){
        final data = json.decode(response.body);
        setState(() {
          NewsResponse newsResponse = NewsResponse.fromJson(data);
          articleList = newsResponse.articles;
        });
      }else{
        print("Failed to fetch data at _fetchArticles() status code");
        print(response.body);
      }
    } catch (e) {
      print("Failed to fetch data at _fetchArticles()");
    }
  }

  Widget _cardArticle(NewsArticle newsArticle, int index, NewsArticle selectedArticle) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: () {
          widget.onArticleTap(1,selectedArticle);
        },
        child: Card(
          margin: const EdgeInsets.all(8),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(newsArticle.title),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Author(s): ${newsArticle.author}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey
                    ),)
                  ],
                ), 
                const Spacer(),
                Text('Publication date: ${newsArticle.pubDate.substring(0,10)}')
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppText.homeHeader),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: articleList.asMap().entries.map((entry) {
            int index = entry.key;
            NewsArticle article = entry.value;
            return _cardArticle(article, index, article);
          }).toList(),
        ),
      ),
    );
  }
}

