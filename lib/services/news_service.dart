import '../config/api_config.dart';
import '../models/article.dart';
import 'api_service.dart';

class NewsService {
  final ApiService _api = ApiService();

  // 获取文章列表
  Future<ArticleListResponse> getArticles({
    int page = 1,
    int pageSize = 20,
    String? category,
    String? keyword,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    if (category != null && category.isNotEmpty) {
      params['category'] = category;
    }
    if (keyword != null && keyword.isNotEmpty) {
      params['keyword'] = keyword;
    }

    // 如果是从旧网站抓取，可能需要走不同的API
    final response = await _api.get('/news', queryParameters: params);
    return ArticleListResponse.fromJson(_api.handleResponse(response));
  }

  // 获取文章详情URL
  Future<String> getArticleDetailUrl(int id) async {
    return 'http://www.landongcn.com/content/?$id.html';
  }
}
