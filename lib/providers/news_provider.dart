import 'package:flutter/foundation.dart';
import '../models/article.dart';
import '../services/news_service.dart';

class NewsProvider with ChangeNotifier {
  final NewsService _service = NewsService();

  List<Article> _articles = [];
  bool _loading = false;
  int _page = 1;
  bool _hasMore = true;
  String _currentCategory = 'gsxw'; // gsxw:公司新闻, hydt:行业动态, cjwt:常见问题

  List<Article> get articles => _articles;
  bool get loading => _loading;
  bool get hasMore => _hasMore;
  String get currentCategory => _currentCategory;

  void setCategory(String category) {
    if (_currentCategory == category) return;
    _currentCategory = category;
    _page = 1;
    _hasMore = true;
    _articles = [];
    loadArticles(refresh: true);
    notifyListeners();
  }

  Future<void> loadArticles({bool refresh = false}) async {
    if (_loading) return;

    if (refresh) {
      _page = 1;
      _hasMore = true;
      _articles = [];
    }

    if (!_hasMore) return;

    _loading = true;
    notifyListeners();

    try {
      final result = await _service.getArticles(
        page: _page,
        category: _currentCategory,
      );

      if (refresh) {
        _articles = result.items;
      } else {
        _articles.addAll(result.items);
      }

      _page++;
      _hasMore = result.items.length >= 20 &&
          _articles.length < result.total;
    } catch (e) {
      debugPrint('加载资讯列表失败: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
