import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/home/home_page.dart';
import '../pages/products/product_list_page.dart';
import '../pages/products/device_detail_page.dart';
import '../pages/products/system_detail_page.dart';
import '../pages/news/news_list_page.dart';
import '../pages/news/news_detail_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/profile/settings_page.dart';
import '../pages/profile/about_page.dart';
import '../widgets/main_scaffold.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/products',
          name: 'products',
          builder: (context, state) => const ProductListPage(),
        ),
        GoRoute(
          path: '/news',
          name: 'news',
          builder: (context, state) => const NewsListPage(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/about',
          name: 'about',
          builder: (context, state) => const AboutPage(),
        ),
      ],
    ),
    // 详情页独立路由，不带底部导航
    GoRoute(
      path: '/device/:id',
      name: 'device-detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return DeviceDetailPage(id: id);
      },
    ),
    GoRoute(
      path: '/system/:id',
      name: 'system-detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return SystemDetailPage(id: id);
      },
    ),
    GoRoute(
      path: '/news/:id',
      name: 'news-detail',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        final title = state.uri.queryParameters['title'] ?? '';
        return NewsDetailPage(id: id, title: title);
      },
    ),
  ],
);
