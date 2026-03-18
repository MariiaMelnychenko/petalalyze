import '../repositories/detections_repository.dart';

/// Use case: upload image to /detect and get detection_id
class DetectImageUseCase {
  DetectImageUseCase({
    required DetectionsRepository repository,
  }) : _repository = repository;

  final DetectionsRepository _repository;

  Future<int> call(String imagePath) => _repository.detectImage(imagePath);
}
