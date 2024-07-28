import 'package:flutter/material.dart';
import 'article_details_page.dart';
import 'articles_page.dart';
import 'package:article_api_app/news_article.dart';


class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
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