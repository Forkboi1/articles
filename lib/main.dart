import 'dart:convert';

import 'package:article_api_app/news_article.dart';
import 'package:article_api_app/news_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Article App",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool disabled = true;
  var newsArticle;

  void _onArticleTap(int index, NewsArticle selectedArticle) {
    setState(() {
      _selectedIndex = index;
      newsArticle = selectedArticle;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = ArticlesPage(onArticleTap: _onArticleTap);
        disabled = true;
        break;
      case 1:
        page = ArticleDetailsPage(article: newsArticle);
        disabled = false;
        break;
      default:
        throw UnimplementedError('no widget for $_selectedIndex');
    }
    return LayoutBuilder(
      builder: (context, constraints){
        return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 300,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home), 
                    label: Text("Home"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.details), 
                    label: Text("View Details"),
                    disabled: disabled,
                  ),
                ],
                selectedIndex: _selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    _selectedIndex = value;
                  });
                }
              )
            ),
            Expanded(
              child: Center(
                child: page,
              ),
            ),
          ],
        ),
      );
      }
    );
  }
}


class ArticlesPage extends StatefulWidget{
  final Function(int, NewsArticle) onArticleTap;

  ArticlesPage({required this.onArticleTap});

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
          margin: EdgeInsets.all(8),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(newsArticle.title),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Author(s): ${newsArticle.author}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey
                    ),)
                  ],
                ), 
                Spacer(),
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
        title: Text("Articles"),
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


class ArticleDetailsPage extends StatelessWidget {
  final NewsArticle article;

  const ArticleDetailsPage({required this.article});

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
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  article.leadParagraph,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}