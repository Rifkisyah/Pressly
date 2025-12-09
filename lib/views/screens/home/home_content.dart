import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pressly/providers/language_provider.dart';
import 'package:pressly/services/article_service.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../article/detailed_news_article.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  // Removed static initialization

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

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
                // Divider(color: (theme.isDarkMode) ? Colors.white : Colors.black, height: 0, thickness: 1, indent: 10, endIndent: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailArticleScreen(article: article),
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
                              Text(
                                article['source_name'] ?? "Unknown Source",
                                style: const TextStyle(color: Colors.grey),
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
    return SizedBox(
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
                        errorBuilder: (_, __, ___) => Container(
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
    );
  }
}
