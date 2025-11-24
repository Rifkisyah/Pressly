import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';

class DetailArticleScreen extends StatelessWidget {
  final Map<String, dynamic> article;

  const DetailArticleScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
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
            icon: const Icon(Icons.share),
            onPressed: () {},
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
            Text(article["author"] ?? "Author"),
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
