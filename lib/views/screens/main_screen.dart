import 'package:flutter/material.dart';
import 'package:pressly/providers/language_provider.dart';
import 'package:pressly/providers/theme_provider.dart';
import 'package:pressly/views/screens/menu/drawer.dart';
import 'package:pressly/views/screens/search/search_screen.dart';
import 'package:pressly/views/screens/video/video_screen.dart';
import 'package:provider/provider.dart';
import 'article/article_screen.dart';
import 'home/home_content.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin{
  late TabController _bottomBartabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _bottomBartabController = TabController(length: 3, vsync: this);
    _bottomBartabController.addListener(() {
      setState(() {
        _selectedIndex = _bottomBartabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final language = Provider.of<LanguageProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: DrawerMenuWidget(),
      ),
      appBar: AppBar(
        title: Image.asset((theme.isDarkMode) ? '../assets/images/logo_app_dark_theme.png' : '../assets/images/logo_app_light_theme.png',
          width: MediaQuery.of(context).size.width * 0.3,
          height: 32,
          fit: BoxFit.contain
        ),
      ),
      body: TabBarView(
        controller: _bottomBartabController,
        children: [
          HomeScreenContent(),
          SearchScreen(),
          ArticleScreen(),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: TabBar(
          controller: _bottomBartabController,
          tabs: [
            Tab(icon: SizedBox(height: 20, width: 20, child: Image.asset('../assets/images/home_outlined_icon.png', color: (theme.isDarkMode) ? Colors.white : (_selectedIndex == 0 ? Colors.white : Colors.black),)), text: language.getText('home')),
            Tab(icon: SizedBox(height: 20, width: 20, child: Image.asset('../assets/images/search_unclicked_icon.png', color: (theme.isDarkMode) ? Colors.white : (_selectedIndex == 3 ? Colors.white : Colors.black))), text: language.getText('search'),),
            Tab(icon: SizedBox(height: 20, width: 20, child: Image.asset('../assets/images/article_unclicked_icon.png', color: (theme.isDarkMode) ? Colors.white : (_selectedIndex == 1 ? Colors.white : Colors.black))), text: language.getText('news'),),
          ],
          labelColor: Colors.white,
          labelPadding: EdgeInsets.symmetric(horizontal: 0),
          unselectedLabelColor: (theme.isDarkMode) ? Colors.white : Colors.black,
          indicatorColor: (theme.isDarkMode) ? Colors.white : Colors.black,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: TextStyle(fontSize: 12),
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: Colors.black,
          ),
        )
      )
    );
  }
}
