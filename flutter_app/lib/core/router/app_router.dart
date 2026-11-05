import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_profile_mobile/presentation/screens/main_navigation_screen.dart';
import 'package:app_profile_mobile/presentation/screens/home/home_screen.dart';
import 'package:app_profile_mobile/presentation/screens/posts/post_list_screen.dart';
import 'package:app_profile_mobile/presentation/screens/posts/post_detail_screen.dart';
import 'package:app_profile_mobile/presentation/screens/pages/page_detail_screen.dart';
import 'package:app_profile_mobile/presentation/screens/questions/question_list_screen.dart';
import 'package:app_profile_mobile/presentation/screens/questions/question_detail_screen.dart';
import 'package:app_profile_mobile/presentation/screens/questions/create_question_screen.dart';
import 'package:app_profile_mobile/presentation/screens/faqs/faq_screen.dart';
import 'package:app_profile_mobile/presentation/screens/settings/settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      // Stateful nested shell for bottom navigation bar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // Branch 2: Posts (News & Articles)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/posts',
                builder: (context, state) => const PostListScreen(),
              ),
            ],
          ),

          // Branch 3: Questions & Public Inquiries
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/questions',
                builder: (context, state) => const QuestionListScreen(),
              ),
            ],
          ),

          // Branch 4: FAQs
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/faqs',
                builder: (context, state) => const FaqScreen(),
              ),
            ],
          ),

          // Branch 5: Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),

      // Detail routes pushed on top of root navigator
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/posts/:slug',
        builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';
          return PostDetailScreen(slug: slug);
        },
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/pages/:slug',
        builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';
          return PageDetailScreen(slug: slug);
        },
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/questions/create',
        builder: (context, state) => const CreateQuestionScreen(),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/questions/:id',
        builder: (context, state) {
          final idString = state.pathParameters['id'] ?? '0';
          final id = int.tryParse(idString) ?? 0;
          return QuestionDetailScreen(id: id);
        },
      ),
    ],
  );
}
