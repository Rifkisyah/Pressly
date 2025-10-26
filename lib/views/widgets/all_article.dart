import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pressly/model/Article.dart';

class HomeScreenAllArticleSegment extends StatefulWidget {
  const HomeScreenAllArticleSegment({super.key});

  @override
  State<HomeScreenAllArticleSegment> createState() => HomeScreenAllArticleSegmentState();
}

class HomeScreenAllArticleSegmentState extends State<HomeScreenAllArticleSegment> {
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
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        _nextSlide();
      }
    });
  }

  void _nextSlide() {
    _currentIndex = (_currentIndex + 1) % 5;
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevSlide() {
    _currentIndex = (_currentIndex - 1 + 5) % 5;
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: 5,
                onPageChanged: (index) {
                  _currentIndex = index;
                },
                itemBuilder: (context, index) {
                  return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Card(
                            color: Colors.black38,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            margin: EdgeInsets.zero,
                            child: Center(child: Text('Item $index', style: const TextStyle(color: Colors.white))),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                              'Judul Artikel',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                              'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,',
                              style: TextStyle(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis
                          ),
                        ),
                        SizedBox(height: 10),
                      ]
                  );
                },

              ),
              Positioned(
                left: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.black45,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.white),
                    onPressed: () {
                      _timer?.cancel();
                      if (_currentIndex > 0) {
                        _prevSlide();
                      } else {
                         _currentIndex = 4;
                         _pageController.jumpToPage(4);
                      }
                      _startAutoScroll();
                    },
                  ),
                ),
              ),
              Positioned(
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.black45,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                    onPressed: () {
                      _timer?.cancel();
                       if (_currentIndex < 4) {
                        _nextSlide();
                      } else {
                         setState(() {
                           _currentIndex = 0;
                         });
                         _pageController.jumpToPage(0);
                      }
                      _startAutoScroll();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: Article.fetchArticles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("ERROR: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No Articles Found"));
              }
              final articles = snapshot.data;
              return ListView.builder(
                itemCount: articles?.length,
                itemBuilder: (context, index) {
                  final article = articles![index];
                  final title = article.articleData['title'];
                  final author = article.articleData['author'];
                  final url = Text(article.articleData['url']);

                  if (title == null || author == null) {
                    return Text("--");
                  }

                  return Column(
                    children: [
                      SizedBox(height: 2, child: Container(color: Colors.grey, margin: EdgeInsets.symmetric(horizontal: 20)),),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: article.articleData['urlToImage'] != null
                                        ? Image.network(
                                      article.articleData['urlToImage'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                    )
                                        : const Icon(Icons.image_not_supported),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          author,
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  )
                                ]
                            )
                        ),
                      )
                    ],
                  );
                }
              );
            }
          ),
        ),
      ],
    );
  }
}
