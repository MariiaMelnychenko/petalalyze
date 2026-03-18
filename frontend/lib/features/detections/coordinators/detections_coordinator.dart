import 'package:petalalyze/core/service_coordinators/dependency_registration.dart';
import 'package:petalalyze/core/service_coordinators/feature_coordinator.dart';
import 'package:petalalyze/features/detections/presentation/cubit/detection_details_cubit.dart';
import 'package:petalalyze/features/detections/presentation/cubit/detection_history_cubit.dart';

/// Coordinator for Detections (History) feature.
class DetectionsCoordinator extends BaseFeatureCoordinator {
  @override
  List<DependencyRegistration> get dependencies => [
        DependencyRegistration<DetectionHistoryCubit>(
          () => DetectionHistoryCubit(),
          isFactory: true,
        ),
        DependencyRegistration<DetectionDetailsCubit>(
          () => DetectionDetailsCubit(),
          isFactory: true,
        ),
      ];
}
