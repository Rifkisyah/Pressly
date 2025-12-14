import 'package:flutter/material.dart';
import 'package:pressly/providers/auth_provider.dart';
import 'package:pressly/views/screens/auth/sign_in_screen.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../providers/theme_provider.dart';

class DetailArticleScreen extends StatelessWidget {
  final Map<String, dynamic> article;

  const DetailArticleScreen({super.key, required this.article});

  void _shareArticle(BuildContext context, bool isLoggedIn) {
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset((theme.isDarkMode) ? '../assets/images/logo_app_dark_theme.png' : '../assets/images/logo_app_light_theme.png', width: MediaQuery.of(context).size.width * 0.3, height: MediaQuery.of(context).size.height * 0.3, fit: BoxFit.contain),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: isLoggedIn 
                  ? (theme.isDarkMode ? Colors.white : Colors.black) 
                  : Colors.grey,
            ),
            tooltip: isLoggedIn ? 'Share article' : 'Login to share',
            onPressed: () => _shareArticle(context, isLoggedIn),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article["title"] ?? "",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(article["source_name"] ?? "Author"),
            const SizedBox(height: 4),
            Text(article["published_at"] ?? "1 jam lalu", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ClipRRect(
                child: article["image"] != null && article["image"] != ""
                    ? Image.network(
                  article["image"],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 230,
                    color: Colors.grey.shade400,
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 50, color: Colors.white),
                    ),
                  ),
                )
                    : Container(
                  height: 230,
                  color: Colors.grey.shade400,
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 50, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(article["description"] ?? "(Deskripsi Gambar)", style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 18),
            Text(
              article["content"] ?? "",
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
