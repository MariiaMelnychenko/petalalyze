import 'package:petalalyze/core/di/injection.dart' as di;
import 'package:petalalyze/core/service_coordinators/dependency_registration.dart';
import 'package:petalalyze/core/service_coordinators/feature_coordinator.dart';
import 'package:petalalyze/core/services/detection_event_bus.dart';
import 'package:petalalyze/features/detections/domain/usecases/get_detection_history_usecase.dart';
import 'package:petalalyze/features/home/presentation/cubit/home_cubit.dart';

/// Coordinator for Home feature.
class HomeCoordinator extends BaseFeatureCoordinator {
  @override
  List<DependencyRegistration> get dependencies => [
        DependencyRegistration<HomeCubit>(
          () => HomeCubit(
            di.sl<GetDetectionHistoryUseCase>(),
            di.sl<DetectionEventBus>(),
          ),
        ),
      ];
}
