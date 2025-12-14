import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/theme_provider.dart';
import '../auth/sign_in_screen.dart';

class DetailedArticleWebview extends StatefulWidget {
  final Map<String, dynamic> article;
  const DetailedArticleWebview({super.key, required this.article});

  @override
  State<DetailedArticleWebview> createState() => _DetailedArticleWebviewState();
}

class _DetailedArticleWebviewState extends State<DetailedArticleWebview> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            if(mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error.description)),
              );
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          }
        )
      )
    ..loadRequest(Uri.parse(widget.article['url']));
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
        title: Image.asset((theme.isDarkMode) ? 'assets/images/logo_app_dark_theme.png' : 'assets/images/logo_app_light_theme.png', width: MediaQuery.of(context).size.width * 0.3, height: MediaQuery.of(context).size.height * 0.3, fit: BoxFit.contain),
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
      body: WebViewWidget(controller: _webViewController),
    );
  }

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
    final title = widget.article['title'] ?? 'Check out this article';
    final url = widget.article['url'] ?? '';
    final source = widget.article['source_name'] ?? 'Pressly';

    final shareText = '$title\n\nRead more: $url\n\nShared via Pressly - $source';

    Share.share(shareText, subject: title);
  }
}
