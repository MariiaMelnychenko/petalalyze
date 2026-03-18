part of 'package:petalalyze/core/routing/app_navigation.dart';

@TypedStatefulShellRoute<RootShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<HomeBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<HomeRoute>(
          path: '/home',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<DetectionResultRoute>(
              path: 'result/:detectionId',
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<CatalogBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<FlowersCatalogRoute>(
          path: '/catalog',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<FlowerDetailsRoute>(
              path: 'flower/:flowerId',
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<HistoryBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<DetectionHistoryRoute>(
          path: '/history',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<DetectionDetailsRoute>(
              path: 'detection/:detectionId',
            ),
          ],
        ),
      ],
    ),
  ],
)
class RootShellRouteData extends StatefulShellRouteData {
  const RootShellRouteData();

  static final GlobalKey<NavigatorState> $navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return RootPage(navigationShell: navigationShell);
  }
}

class HomeBranch extends StatefulShellBranchData {
  const HomeBranch();
}

class CatalogBranch extends StatefulShellBranchData {
  const CatalogBranch();
}

class HistoryBranch extends StatefulShellBranchData {
  const HistoryBranch();
}
