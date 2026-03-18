import 'package:go_router/go_router.dart';

import 'app_navigation.dart';

export 'app_navigation.dart';

/// Конфігурація GoRouter для застосунку.
class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: const HomeRoute().location,
    routes: $appRoutes,
  );
}
