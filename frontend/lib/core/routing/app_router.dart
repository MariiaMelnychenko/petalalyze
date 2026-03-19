import 'package:go_router/go_router.dart';

import 'app_navigation.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

export 'app_navigation.dart';

/// Конфігурація GoRouter для застосунку.
class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      ...$appRoutes,
    ],
  );
}
