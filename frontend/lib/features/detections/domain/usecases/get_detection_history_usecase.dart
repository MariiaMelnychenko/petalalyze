import '../entities/detection_list_item.dart';
import '../repositories/detections_repository.dart';

/// Use case: get detection history for current device
class GetDetectionHistoryUseCase {
  GetDetectionHistoryUseCase(this._repository);

  final DetectionsRepository _repository;

  Future<List<DetectionListItem>> call() => _repository.getDetections();
}
