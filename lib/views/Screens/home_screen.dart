import 'package:flutter/material.dart';
import 'package:pressly/views/Screens/article_screen.dart';
import 'package:pressly/views/Screens/search_screen.dart';
import 'package:pressly/views/Screens/video_screen.dart';
import 'package:pressly/views/widgets/drawer.dart';
import '../widgets/all_article.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{
  late TabController _appBartabController;
  late TabController _bottomBartabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _appBartabController = TabController(length: 5, vsync: this);
    _bottomBartabController = TabController(length: 4, vsync: this);
    _bottomBartabController.addListener(() {
      setState(() {
        _selectedIndex = _bottomBartabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: DrawerMenuWidget(),
        ),
        appBar: AppBar(
          title: Image.asset('../assets/images/logo_app.png', width: MediaQuery.of(context).size.width * 0.3, height: MediaQuery.of(context).size.height * 0.3, fit: BoxFit.contain),
          bottom: TabBar(
            controller: _appBartabController,
            tabs: [
              Tab(text: 'Semua'),
              Tab(text: 'Internasional'),
              Tab(text: 'Bisnis'),
              Tab(text: 'Teknologi'),
              Tab(text: 'Seni',)
            ],
            labelColor: Colors.white,
            labelPadding: EdgeInsets.symmetric(horizontal: 0),
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: TextStyle(fontSize: 12),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              color: Colors.black,
            ),
          ),
        ),
        body: TabBarView(
          controller: _bottomBartabController,
          children: [
            HomeScreenAllArticleSegment(),
            ArticleScreen(),
            VideoScreen(),
            SearchScreen()
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: TabBar(
            controller: _bottomBartabController,
            tabs: [
              Tab(icon: SizedBox(height: 20, width: 20, child: Image.asset('../assets/images/home_unclicked_icon.png', color: _selectedIndex == 0 ? Colors.white : Colors.black)), text: 'Beranda'),
              Tab(icon: SizedBox(height: 20, width: 20, child: Image.asset('../assets/images/article_unclicked_icon.png', color: _selectedIndex == 1 ? Colors.white : Colors.black)), text: 'Berita',),
              Tab(icon: SizedBox(height: 20, width: 20, child: Image.asset('../assets/images/video_unclicked_icon.png', color: _selectedIndex == 2 ? Colors.white : Colors.black)), text: 'Video',),
              Tab(icon: SizedBox(height: 20, width: 20, child: Image.asset('../assets/images/search_unclicked_icon.png', color: _selectedIndex == 3 ? Colors.white : Colors.black)), text: 'Cari',),
            ],
            labelColor: Colors.white,
            labelPadding: EdgeInsets.symmetric(horizontal: 0),
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.black,
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
