import 'package:flutter/material.dart';
import 'package:pressly/views/screens/article/list_article.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});

  @override
  State<ArticleScreen> createState() => _ArticleScreenstate();
}

class _ArticleScreenstate extends State<ArticleScreen> with TickerProviderStateMixin{
  late TabController _categoryController;
  late int _categoryIndex;

  @override
  void initState() {
    super.initState();
    _categoryController = TabController(length: 9, vsync: this);
    _categoryController.addListener(() {
      setState(() {
        _categoryIndex = _categoryController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        TabBar(
          controller: _categoryController,
          isScrollable: true,
          tabs: [
            Tab(text: 'General',),
            Tab(text: 'World'),
            Tab(text: 'Nation'),
            Tab(text: 'Business'),
            Tab(text: 'Technology',),
            Tab(text: 'Entertaiment',),
            Tab(text: 'Sports',),
            Tab(text: 'Science',),
            Tab(text: 'Health',),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: (theme.isDarkMode) ? Colors.white : Colors.black,
          indicatorColor: (theme.isDarkMode) ? Colors.white : Colors.black,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: TextStyle(fontSize: 12),
          tabAlignment: TabAlignment.start,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: Colors.black,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _categoryController,
            children: [
              ListArticle(category: "general"),
              ListArticle(category: "world"),
              ListArticle(category: "nation"),
              ListArticle(category: "business"),
              ListArticle(category: "technology"),
              ListArticle(category: "entertainment"),
              ListArticle(category: "sports"),
              ListArticle(category: "science"),
              ListArticle(category: "health"),
              ],
            ),
        )
      ]
    );
  }
}
