import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/news_provider.dart';
import '../../models/article.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _tabs = const [
    {'id': 'gsxw', 'name': '公司新闻'},
    {'id': 'hydt', 'name': '行业动态'},
    {'id': 'cjwt', 'name': '常见问题'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).loadNews('gsxw');
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final tabId = _tabs[_tabController.index]['id']!;
    Provider.of<NewsProvider>(context, listen: false).loadNews(tabId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('资讯'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab['name'])).toList(),
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey[600],
          indicatorSize: TabBarIndicatorSize.label,
          indicatorWeight: 3,
        ),
      ),
      body: Consumer<NewsProvider>(
        builder: (context, provider, child) {
          return TabBarView(
            controller: _tabController,
            children: _tabs.map((tab) {
              return _buildNewsList(provider, tab['id']!);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildNewsList(NewsProvider provider, String category) {
    final news = provider.getNewsByCategory(category);
    final isLoading = provider.isLoading;

    if (isLoading && news.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (news.isEmpty) {
      return const Center(child: Text('暂无资讯'));
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadNews(category),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: news.length,
        itemBuilder: (context, index) {
          final article = news[index];
          return _buildNewsItem(article);
        },
      ),
    );
  }

  Widget _buildNewsItem(Article article) {
    // 格式化日期
    String dateStr = '';
    if (article.publishedAt != null) {
      dateStr = '${article.publishedAt!.year}-${article.publishedAt!.month.toString().padLeft(2, '0')}-${article.publishedAt!.day.toString().padLeft(2, '0')}';
    } else if (article.createdAt != null) {
      dateStr = '${article.createdAt!.year}-${article.createdAt!.month.toString().padLeft(2, '0')}-${article.createdAt!.day.toString().padLeft(2, '0')}';
    }

    return GestureDetector(
      onTap: () => context.push('/news/${article.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (article.summary != null && article.summary!.isNotEmpty)
                    Text(
                      article.summary!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (article.image != null && article.image!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: article.image!,
                  width: 90,
                  height: 70,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    width: 90,
                    height: 70,
                    color: Colors.grey[200],
                    child: const Icon(Icons.article, color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
