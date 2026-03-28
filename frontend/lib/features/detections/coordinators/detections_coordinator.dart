import 'package:petalalyze/core/di/injection.dart' as di;
import 'package:petalalyze/core/network/network_client.dart';
import 'package:petalalyze/core/service_coordinators/dependency_registration.dart';
import 'package:petalalyze/core/service_coordinators/feature_coordinator.dart';
import 'package:petalalyze/core/services/detection_event_bus.dart';
import 'package:petalalyze/core/services/device_id_service.dart';
import 'package:petalalyze/features/detections/data/datasources/detections_remote_datasource.dart';
import 'package:petalalyze/features/detections/data/repositories/detections_repository_impl.dart';
import 'package:petalalyze/features/detections/domain/repositories/detections_repository.dart';
import 'package:petalalyze/features/detections/domain/usecases/delete_detection_usecase.dart';
import 'package:petalalyze/features/detections/domain/usecases/get_detection_details_usecase.dart';
import 'package:petalalyze/features/detections/domain/usecases/get_detection_history_usecase.dart';
import 'package:petalalyze/features/detections/domain/usecases/predict_image_usecase.dart';
import 'package:petalalyze/features/detections/presentation/cubit/detection_details_cubit.dart';
import 'package:petalalyze/features/detections/presentation/cubit/detection_history_cubit.dart';
import 'package:petalalyze/features/detections/presentation/cubit/predict_result_cubit.dart';

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
        DependencyRegistration<GetDetectionDetailsUseCase>(
          () => GetDetectionDetailsUseCase(di.sl<DetectionsRepository>()),
        ),
        DependencyRegistration<PredictImageUseCase>(
          () => PredictImageUseCase(repository: di.sl<DetectionsRepository>()),
        ),
        DependencyRegistration<DeleteDetectionUseCase>(
          () => DeleteDetectionUseCase(
              repository: di.sl<DetectionsRepository>()),
        ),
        DependencyRegistration<DetectionHistoryCubit>(
          () => DetectionHistoryCubit(
            di.sl<GetDetectionHistoryUseCase>(),
            di.sl<DeleteDetectionUseCase>(),
            di.sl<DetectionEventBus>(),
          ),
        ),
        DependencyRegistration<DetectionDetailsCubit>(
          () => DetectionDetailsCubit(di.sl<GetDetectionDetailsUseCase>()),
          isFactory: true,
        ),
        DependencyRegistration<PredictResultCubit>(
          () => PredictResultCubit(
            di.sl<PredictImageUseCase>(),
            di.sl<DetectionEventBus>(),
          ),
          isFactory: true,
        ),
      ];
}
