import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import '../../features/onboarding/presentation/pages/introduction_page.dart';
import '../../features/onboarding/presentation/pages/how_posting_works_page.dart';
import '../../features/onboarding/presentation/pages/create_first_reflection_page.dart';
import '../../features/shell/presentation/pages/shell_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/communities/presentation/pages/communities_page.dart';
import '../../features/feed/presentation/pages/my_feed_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/home/presentation/pages/post_detail_page.dart';

/// Route path constants
abstract final class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String introduction = '/introduction';
  static const String howPostingWorks = '/how-posting-works';
  static const String createFirstReflection = '/create-first-reflection';
  static const String shell = '/home';
  static const String home = '/home/feed';
  static const String communities = '/home/communities';
  static const String myFeed = '/home/my-feed';
  static const String profile = '/home/profile';
  static const String postDetail = '/post/:id';
}

final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SplashPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        pageBuilder: (context, state) => const MaterialPage(
          child: WelcomePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.introduction,
        pageBuilder: (context, state) => const MaterialPage(
          child: IntroductionPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.howPostingWorks,
        pageBuilder: (context, state) => const MaterialPage(
          child: HowPostingWorksPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.createFirstReflection,
        pageBuilder: (context, state) => const MaterialPage(
          child: CreateFirstReflectionPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.postDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final postId = state.pathParameters['id'] ?? '';
          return MaterialPage(
            child: PostDetailPage(postId: postId),
          );
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        pageBuilder: (context, state, child) => NoTransitionPage(
          child: ShellPage(child: child),
        ),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.communities,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CommunitiesPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.myFeed,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MyFeedPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilePage(),
            ),
          ),
        ],
      ),
    ],
  );
}
