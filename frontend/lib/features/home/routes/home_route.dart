part of 'package:petalalyze/core/routing/app_navigation.dart';

class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<HomeCubit>()),
        BlocProvider(
          create: (_) {
            final cubit = di.sl<DetectionHistoryCubit>();
            cubit.load();
            return cubit;
          },
        ),
      ],
      child: const HomePage(),
    );
  }
}

class DetectionResultRoute extends GoRouteData with $DetectionResultRoute {
  const DetectionResultRoute({required this.detectionId});

  final String detectionId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (_) => di.sl<HomeCubit>(),
      child: DetectionResultPage(detectionId: detectionId),
    );
  }
}
