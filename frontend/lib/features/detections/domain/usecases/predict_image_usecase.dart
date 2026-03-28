import '../entities/predict_result.dart';
import '../repositories/detections_repository.dart';

/// Use case: send image to /predict and receive ensemble predictions.
class PredictImageUseCase {
  PredictImageUseCase({required DetectionsRepository repository})
      : _repository = repository;

  final DetectionsRepository _repository;

  Future<PredictResult> call(String imagePath) =>
      _repository.predictImage(imagePath);
}
