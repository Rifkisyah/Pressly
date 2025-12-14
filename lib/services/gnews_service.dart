import 'dart:convert';
import 'package:http/http.dart' as http;

class GNewsService {
  // GNews API Key - Get yours free at https://gnews.io/
  // Free tier: 100 requests/day
  static const String _apiKey = 'YOUR_GNEWS_API_KEY'; // Replace with your API key
  static const String _baseUrl = 'https://gnews.io/api/v4';

  /// Fetch top headlines
  /// [category] can be: general, world, nation, business, technology, entertainment, sports, science, health
  /// [lang] language code (e.g., 'en', 'id')
  /// [country] country code (e.g., 'us', 'id')
  /// [max] number of articles (max 10 for free tier)
  static Future<List<Map<String, dynamic>>> fetchTopHeadlines({
    String category = 'general',
    String lang = 'en',
    String? country,
    int max = 10,
  }) async {
    try {
      String url = '$_baseUrl/top-headlines?category=$category&lang=$lang&max=$max&apikey=$_apiKey';
      
      if (country != null) {
        url += '&country=$country';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = data['articles'] as List<dynamic>;
        
        return articles.map((article) => _mapGNewsArticle(article)).toList();
      } else {
        throw Exception('Failed to fetch news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching GNews: $e');
    }
  }

  /// Search for news articles
  /// [query] search query
  /// [lang] language code
  /// [max] number of articles
  static Future<List<Map<String, dynamic>>> searchNews({
    required String query,
    String lang = 'en',
    int max = 10,
  }) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = '$_baseUrl/search?q=$encodedQuery&lang=$lang&max=$max&apikey=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = data['articles'] as List<dynamic>;
        
        return articles.map((article) => _mapGNewsArticle(article)).toList();
      } else {
        throw Exception('Failed to search news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching GNews: $e');
    }
  }

  /// Fetch news by category
  static Future<List<Map<String, dynamic>>> fetchByCategory(String category, {String lang = 'en'}) async {
    return fetchTopHeadlines(category: category, lang: lang);
  }

  /// Map GNews article format to our app format
  static Map<String, dynamic> _mapGNewsArticle(Map<String, dynamic> article) {
    return {
      'title': article['title'] ?? '',
      'description': article['description'] ?? '',
      'content': article['content'] ?? '',
      'url': article['url'] ?? '',
      'image': article['image'] ?? '',
      'published_at': article['publishedAt'] ?? '',
      'source_name': article['source']?['name'] ?? 'Unknown',
      'source_url': article['source']?['url'] ?? '',
      'category': 'general', // GNews doesn't return category in response
    };
  }
}
