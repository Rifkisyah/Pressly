import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pressly/services/article_service.dart';
import '../article/detailed_news_article.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  final Future<List<Map<String, dynamic>>> futureArticles = ArticleService.fetchArticles();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: futureArticles,
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

        return Column(
          children: [
            CarouselSection(topFive: topFive),
            Expanded(
              child: ListView.builder(
                itemCount: allArticles.length,
                itemBuilder: (context, index) {
                  final article = allArticles[index];

                  return Column(
                    children: [
                      SizedBox(height: 15,),
                      Divider(color: Colors.grey.shade400, height: 0, thickness: 4, indent: 10, endIndent: 10),
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
                                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                                    ) : Center(
                                      child: Container(
                                        width: 500,
                                        height: 120,
                                        color: Colors.grey.shade400,
                                        child: const Icon(Icons.image_not_supported, size: 50, color: Colors.white),
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
              ),
            ),
          ],
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
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.black26,
                          child: const Icon(Icons.broken_image, size: 50, color: Colors.white),
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
