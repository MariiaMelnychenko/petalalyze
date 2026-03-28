import '../repositories/detections_repository.dart';

/// Use case: delete a detection from history.
class DeleteDetectionUseCase {
  DeleteDetectionUseCase({required DetectionsRepository repository})
      : _repository = repository;

  final DetectionsRepository _repository;

  Future<void> call(int id) => _repository.deleteDetection(id);
}
