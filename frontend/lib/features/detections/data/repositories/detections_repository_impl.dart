import '../../domain/entities/detection_detail.dart';
import '../../domain/entities/detection_list_item.dart';
import '../../domain/entities/predict_result.dart';
import '../../domain/repositories/detections_repository.dart';
import '../datasources/detections_remote_datasource.dart';

class DetectionsRepositoryImpl implements DetectionsRepository {
  DetectionsRepositoryImpl({
    required DetectionsRemoteDatasource remoteDatasource,
  }) : _remote = remoteDatasource;

  final DetectionsRemoteDatasource _remote;

  @override
  Future<List<DetectionListItem>> getDetections() async {
    final models = await _remote.getDetections();
    return List<DetectionListItem>.from(models);
  }

  @override
  Future<DetectionDetail> getDetectionById(int id) =>
      _remote.getDetectionById(id);

  @override
  Future<PredictResult> predictImage(String imagePath) =>
      _remote.predictImage(imagePath);

  @override
  Future<void> deleteDetection(int id) => _remote.deleteDetection(id);
}
