import 'package:flutter/material.dart';
import 'package:pressly/providers/auth_provider.dart';
import 'package:pressly/providers/theme_provider.dart';
import 'package:pressly/views/screens/auth/sign_in_screen.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../services/article_service.dart';
import 'detailed_news_article.dart';

class ListArticle extends StatefulWidget {
  final String category;

  const ListArticle({super.key, required this.category});

  @override
  State<ListArticle> createState() => _ListArticleState();
}

class _ListArticleState extends State<ListArticle> {

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
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);
    final isLoggedIn = authProvider.isAuthenticated;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ArticleService.fetchArticlesByCategory(widget.category),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("ERROR: ${snapshot.error}"));
        }
        if(!snapshot.hasData || snapshot.data!.isEmpty){
          return const Center(child: Text("No Articles Found"));
        }
        final allArticles = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: allArticles.length,
                itemBuilder: (context, index) {
                  final article = allArticles[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailArticleScreen(article: article),
                            )
                        ),
                        child: Column(
                          children: [
                            article['image'] != null && article['image'] != ""
                                ? Image.network(
                              article['image'],
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(
                                heightFactor: 3,
                                child: Icon(Icons.broken_image, size: 50,),
                              ),
                            )
                                : const Center(
                              child: Icon(Icons.broken_image, size: 50),
                            ),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(article['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                            ),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(article['description'], style: TextStyle(fontSize: 12),),
                            ),
                            SizedBox(height: 10,),
                            // Share button
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.share,
                                      color: isLoggedIn 
                                          ? (theme.isDarkMode ? Colors.white : Colors.black) 
                                          : Colors.grey,
                                      size: 20,
                                    ),
                                    tooltip: isLoggedIn ? 'Share article' : 'Login to share',
                                    onPressed: () => _shareArticle(article, isLoggedIn),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,)
                          ]
                        ),
                      )
                    ],
                  );
                }
              ),
            )
          ]
        );
      }
    );
  }
}
