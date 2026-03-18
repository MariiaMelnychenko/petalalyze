// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_navigation.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $rootShellRouteData,
    ];

RouteBase get $rootShellRouteData => StatefulShellRouteData.$route(
      factory: $RootShellRouteDataExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/home',
              factory: $HomeRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'result/:detectionId',
                  factory: $DetectionResultRoute._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/catalog',
              factory: $FlowersCatalogRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'flower/:flowerId',
                  factory: $FlowerDetailsRoute._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/history',
              factory: $DetectionHistoryRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'detection/:detectionId',
                  factory: $DetectionDetailsRoute._fromState,
                ),
              ],
            ),
          ],
        ),
      ],
    );

extension $RootShellRouteDataExtension on RootShellRouteData {
  static RootShellRouteData _fromState(GoRouterState state) =>
      const RootShellRouteData();
}

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location(
        '/home',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DetectionResultRoute on GoRouteData {
  static DetectionResultRoute _fromState(GoRouterState state) =>
      DetectionResultRoute(
        detectionId: state.pathParameters['detectionId']!,
      );

  DetectionResultRoute get _self => this as DetectionResultRoute;

  @override
  String get location => GoRouteData.$location(
        '/home/result/${Uri.encodeComponent(_self.detectionId)}',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FlowersCatalogRoute on GoRouteData {
  static FlowersCatalogRoute _fromState(GoRouterState state) =>
      const FlowersCatalogRoute();

  @override
  String get location => GoRouteData.$location(
        '/catalog',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FlowerDetailsRoute on GoRouteData {
  static FlowerDetailsRoute _fromState(GoRouterState state) =>
      FlowerDetailsRoute(
        flowerId: state.pathParameters['flowerId']!,
      );

  FlowerDetailsRoute get _self => this as FlowerDetailsRoute;

  @override
  String get location => GoRouteData.$location(
        '/catalog/flower/${Uri.encodeComponent(_self.flowerId)}',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DetectionHistoryRoute on GoRouteData {
  static DetectionHistoryRoute _fromState(GoRouterState state) =>
      const DetectionHistoryRoute();

  @override
  String get location => GoRouteData.$location(
        '/history',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DetectionDetailsRoute on GoRouteData {
  static DetectionDetailsRoute _fromState(GoRouterState state) =>
      DetectionDetailsRoute(
        detectionId: state.pathParameters['detectionId']!,
      );

  DetectionDetailsRoute get _self => this as DetectionDetailsRoute;

  @override
  String get location => GoRouteData.$location(
        '/history/detection/${Uri.encodeComponent(_self.detectionId)}',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
