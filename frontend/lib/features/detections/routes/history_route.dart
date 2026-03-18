part of 'package:petalalyze/core/routing/app_navigation.dart';

class DetectionHistoryRoute extends GoRouteData with $DetectionHistoryRoute {
  const DetectionHistoryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (_) {
        final cubit = di.sl<DetectionHistoryCubit>();
        cubit.load();
        return cubit;
      },
      child: const DetectionHistoryPage(),
    );
  }
}

class DetectionDetailsRoute extends GoRouteData with $DetectionDetailsRoute {
  const DetectionDetailsRoute({required this.detectionId});

  final String detectionId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (_) => di.sl<DetectionDetailsCubit>(),
      child: DetectionDetailsPage(detectionId: detectionId),
    );
  }
}
