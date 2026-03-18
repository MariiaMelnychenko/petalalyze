part of 'package:petalalyze/core/routing/app_navigation.dart';

class FlowersCatalogRoute extends GoRouteData with $FlowersCatalogRoute {
  const FlowersCatalogRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (_) => di.sl<FlowersCatalogCubit>()..loadFlowers(),
      child: const FlowersCatalogPage(),
    );
  }
}

class FlowerDetailsRoute extends GoRouteData with $FlowerDetailsRoute {
  const FlowerDetailsRoute({required this.flowerId});

  final String flowerId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final id = int.tryParse(flowerId) ?? 0;
    return BlocProvider(
      create: (_) => di.sl<FlowerDetailsCubit>()..loadFlower(id),
      child: FlowerDetailsPage(flowerId: flowerId),
    );
  }
}
