part of 'package:petalalyze/core/routing/app_navigation.dart';

class DetectionHistoryRoute extends GoRouteData with $DetectionHistoryRoute {
  const DetectionHistoryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final cubit = di.sl<DetectionHistoryCubit>();
    cubit.load();
    return BlocProvider.value(
      value: cubit,
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
      create: (_) {
        final cubit = di.sl<DetectionDetailsCubit>();
        final id = int.tryParse(detectionId);
        if (id != null) {
          cubit.load(id);
        }
        return cubit;
      },
      child: DetectionDetailsPage(detectionId: detectionId),
    );
  }
}
