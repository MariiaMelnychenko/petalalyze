import 'package:petalalyze/core/di/injection.dart' as di;
import 'package:petalalyze/core/network/network_client.dart';
import 'package:petalalyze/core/service_coordinators/dependency_registration.dart';
import 'package:petalalyze/core/service_coordinators/feature_coordinator.dart';
import 'package:petalalyze/core/services/device_id_service.dart';
import 'package:petalalyze/features/detections/data/datasources/detections_remote_datasource.dart';
import 'package:petalalyze/features/detections/data/repositories/detections_repository_impl.dart';
import 'package:petalalyze/features/detections/domain/repositories/detections_repository.dart';
import 'package:petalalyze/features/detections/domain/usecases/get_detection_history_usecase.dart';
import 'package:petalalyze/features/detections/presentation/cubit/detection_details_cubit.dart';
import 'package:petalalyze/features/detections/presentation/cubit/detection_history_cubit.dart';

/// Coordinator for Detections (History) feature.
class DetectionsCoordinator extends BaseFeatureCoordinator {
  @override
  List<DependencyRegistration> get dependencies => [
        DependencyRegistration<DetectionsRemoteDatasource>(
          () => DetectionsRemoteDatasourceImpl(
            dio: di.sl<NetworkClient>().dio,
            deviceIdService: di.sl<DeviceIdService>(),
          ),
        ),
        DependencyRegistration<DetectionsRepositoryImpl>(
          () => DetectionsRepositoryImpl(
            remoteDatasource: di.sl<DetectionsRemoteDatasource>(),
          ),
        ),
        DependencyRegistration<DetectionsRepository>(
          () => di.sl<DetectionsRepositoryImpl>(),
        ),
        DependencyRegistration<GetDetectionHistoryUseCase>(
          () => GetDetectionHistoryUseCase(di.sl<DetectionsRepository>()),
        ),
        DependencyRegistration<DetectionHistoryCubit>(
          () => DetectionHistoryCubit(di.sl<GetDetectionHistoryUseCase>()),
          isFactory: true,
        ),
        DependencyRegistration<DetectionDetailsCubit>(
          () => DetectionDetailsCubit(),
          isFactory: true,
        ),
      ];
}
