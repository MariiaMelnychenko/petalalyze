part of 'package:petalalyze/core/routing/app_navigation.dart';

class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final cubit = di.sl<HomeCubit>();
    cubit.loadDetectionHistory();
    return BlocProvider.value(
      value: cubit,
      child: const HomePage(),
    );
  }
}

class DetectionResultRoute extends GoRouteData with $DetectionResultRoute {
  const DetectionResultRoute({required this.detectionId});

  final String detectionId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider.value(
      value: di.sl<HomeCubit>(),
      child: DetectionResultPage(detectionId: detectionId),
    );
  }
}

class PredictResultRoute extends GoRouteData with $PredictResultRoute {
  const PredictResultRoute({this.$extra});

  final String? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (_) {
        final cubit = di.sl<PredictResultCubit>();
        if ($extra != null) cubit.predict($extra!);
        return cubit;
      },
      child: const PredictResultPage(),
    );
  }
}
