import 'package:flutter/foundation.dart';
import '../models/article.dart';
import '../services/news_service.dart';

class NewsProvider with ChangeNotifier {
  final NewsService _service = NewsService();

  // 按分类存储
  final Map<String, List<Article>> _articlesByCategory = {};
  bool _loading = false;
  String _currentCategory = 'gsxw';

  bool get loading => _loading;
  bool get isLoading => _loading;
  String get currentCategory => _currentCategory;

  List<Article> get articles => _articlesByCategory[_currentCategory] ?? [];

  List<Article> getNewsByCategory(String category) {
    return _articlesByCategory[category] ?? [];
  }

  Future<void> loadNews(String category) async {
    if (_loading) return;

    _currentCategory = category;
    _loading = true;
    notifyListeners();

    try {
      final result = await _service.getArticles(
        page: 1,
        category: category,
      );
      _articlesByCategory[category] = result.items;
    } catch (e) {
      debugPrint('加载资讯列表失败: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadArticles({bool refresh = false}) async {
    await loadNews(_currentCategory);
  }
}
