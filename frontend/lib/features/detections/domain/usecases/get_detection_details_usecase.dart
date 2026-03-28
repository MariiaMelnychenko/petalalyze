import '../entities/detection_detail.dart';
import '../repositories/detections_repository.dart';

class GetDetectionDetailsUseCase {
  GetDetectionDetailsUseCase(this._repository);

  final DetectionsRepository _repository;

  Future<DetectionDetail> call(int id) => _repository.getDetectionById(id);
}
