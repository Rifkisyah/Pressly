import 'package:flutter/material.dart';
import 'package:pressly/views/screens/article/detailed_article_webview.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../services/article_service.dart';

class ResultList extends StatelessWidget {
  final String keyword;
  final String? category;
  final String? country;
  final String? source;

  const ResultList({
    super.key,
    required this.keyword,
    this.category,
    this.country,
    this.source,
  });

  Future<List<Map<String, dynamic>>> _search() async {
    final all = await ArticleService.fetchArticles();

    return all.where((item) {
      final title = (item['title'] ?? '').toLowerCase();
      final key = keyword.toLowerCase();

      bool matchKeyword = key.isEmpty ? true : title.contains(key);
      bool matchCategory = category == null || item['category'] == category;
      bool matchCountry = country == null || item['country'] == country;
      bool matchSource =
          source == null || item['source_name'] == source;

      return matchKeyword && matchCategory && matchCountry && matchSource;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _search(),
      builder: (context, snapshot) {
        // LOADING
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final list = snapshot.data!;

        if (list.isEmpty) {
          return Center(
            child: Text(
              "No results found.",
              style: TextStyle(
                color:
                theme.isDarkMode ? Colors.white70 : Colors.black54,
                fontSize: 16,
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final item = list[i];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailedArticleWebview(article: item),
                  ),
                );
              },
              child: Container(
                height: 90,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.isDarkMode
                      ? const Color(0xFF2A2A2A)
                      : const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    // IMAGE
                    SizedBox(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: item['image'] != null ? Image.network(
                            item['image'],
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

                    const SizedBox(width: 12),

                    // TITLE + SOURCE
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["title"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            item["source_name"] ?? "Unknown source",
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.isDarkMode
                                  ? Colors.white70
                                  : Colors.black54,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
