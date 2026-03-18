import 'package:petalalyze/core/service_coordinators/dependency_registration.dart';
import 'package:petalalyze/core/service_coordinators/feature_coordinator.dart';
import 'package:petalalyze/features/home/presentation/cubit/home_cubit.dart';

/// Coordinator for Home feature.
class HomeCoordinator extends BaseFeatureCoordinator {
  @override
  List<DependencyRegistration> get dependencies => [
        DependencyRegistration<HomeCubit>(
          () => HomeCubit(),
          isFactory: true,
        ),
      ];
}
