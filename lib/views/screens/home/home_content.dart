import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pressly/providers/auth_provider.dart';
import 'package:pressly/services/article_service.dart';
import 'package:pressly/views/screens/article/detailed_article_webview.dart';
import 'package:pressly/views/screens/auth/sign_in_screen.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../providers/theme_provider.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {

  void _shareArticle(Map<String, dynamic> article, bool isLoggedIn) {
    if (!isLoggedIn) {
      // Show login required dialog
      showDialog(
        context: context,
        builder: (context) {
          final theme = Provider.of<ThemeProvider>(context);
          return AlertDialog(
            backgroundColor: theme.isDarkMode ? Colors.grey[900] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: theme.isDarkMode ? Colors.white : Colors.black,
                width: 1,
              ),
            ),
            title: Text(
              'Login Required',
              style: TextStyle(
                color: theme.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'You need to login to share articles. Would you like to login now?',
              style: TextStyle(
                color: theme.isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: theme.isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: theme.isDarkMode ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: theme.isDarkMode ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    // User is logged in, share the article
    final title = article['title'] ?? 'Check out this article';
    final url = article['url'] ?? '';
    final source = article['source_name'] ?? 'Pressly';
    
    final shareText = '$title\n\nRead more: $url\n\nShared via Pressly - $source';
    
    Share.share(shareText, subject: title);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoggedIn = authProvider.isAuthenticated;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ArticleService.fetchArticles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("ERROR: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No Articles Found"));
        }

        final allArticles = snapshot.data!;
        final topFive = allArticles.take(5).toList();

        return ListView.builder(
          itemCount: allArticles.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return CarouselSection(topFive: topFive);
            }
            final article = allArticles[index - 1];

            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailedArticleWebview(article: article),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: (theme.isDarkMode) ? Colors.black26 : Colors.white,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: article['image'] != null ? Image.network(
                              article['image'],
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(Icons.broken_image, color: (theme.isDarkMode) ? Colors.white : Colors.grey.shade400,),
                              ) : Center(
                                child: Container(
                                  width: 500,
                                  height: 120,
                                  color: (theme.isDarkMode) ? Colors.white : Colors.grey.shade400,
                                  child: Icon(Icons.image_not_supported, size: 80, color: (theme.isDarkMode) ? Colors.white : Colors.grey.shade400,),
                                ),
                              ),
                          )
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article['title'] ?? "No Title",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      article['source_name'] ?? "Unknown Source",
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.share,
                                      size: 18,
                                      color: isLoggedIn 
                                          ? (theme.isDarkMode ? Colors.white : Colors.black) 
                                          : Colors.grey,
                                    ),
                                    tooltip: isLoggedIn ? 'Share' : 'Login to share',
                                    onPressed: () => _shareArticle(article, isLoggedIn),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}

class CarouselSection extends StatefulWidget {
  final List<Map<String, dynamic>> topFive;

  const CarouselSection({super.key, required this.topFive});

  @override
  State<CarouselSection> createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<CarouselSection> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      _nextSlide();
    });
  }

  void _nextSlide() {
    setState(() => _currentIndex = (_currentIndex + 1) % widget.topFive.length);
    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  void _prevSlide() {
    setState(() => _currentIndex = (_currentIndex - 1 + widget.topFive.length) % widget.topFive.length);
    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap: () {
        if (_currentIndex >= 0 && _currentIndex < widget.topFive.length) {
          final item = widget.topFive[_currentIndex];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailedArticleWebview(article: item),
            ),
          );
        }
      },
      child: SizedBox(
        height: 250,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.topFive.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (context, index) {
                final item = widget.topFive[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        child: item['image'] != null
                            ? Image.network(
                          item['image'],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: (theme.isDarkMode) ? Colors.white : Colors.grey.shade400,
                                ),
                              )
                          ),
                        )
                            : Container(
                          color: Colors.black26,
                          child: const Icon(Icons.image_not_supported, size: 40, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        item['title'] ?? "No Title",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        item['description'] ?? "No description",
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              left: 10,
              top: 90,
              child: CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.white),
                  onPressed: () {
                    _timer?.cancel();
                    _prevSlide();
                    _startAutoScroll();
                  },
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 90,
              child: CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                  onPressed: () {
                    _timer?.cancel();
                    _nextSlide();
                    _startAutoScroll();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
