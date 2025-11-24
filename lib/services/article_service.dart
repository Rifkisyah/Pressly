import 'package:supabase_flutter/supabase_flutter.dart';

class ArticleService {
  static final supabase = Supabase.instance.client;

  /// Ambil semua artikel dari table `news`
  static Future<List<Map<String, dynamic>>> fetchArticles() async {
    final List<dynamic> response = await supabase
        .from('news_article')
        .select()
        .order('published_at', ascending: false);

    return response.cast<Map<String, dynamic>>();
  }

  /// Ambil artikel berdasarkan ID
  static Future<Map<String, dynamic>?> fetchArticleById(String id) async {
    final response = await supabase
        .from('news')
        .select()
        .eq('id', id)
        .maybeSingle();

    return response;
  }

  /// Insert 1 artikel (misalnya dari News API)
  static Future<void> insertArticle(Map<String, dynamic> data) async {
    await supabase.from('news').insert(data);
  }

  /// Hapus artikel
  static Future<void> deleteArticle(String id) async {
    await supabase.from('news').delete().eq('id', id);
  }
}
