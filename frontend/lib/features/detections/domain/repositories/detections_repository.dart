import '../entities/detection_detail.dart';
import '../entities/detection_list_item.dart';
import '../entities/predict_result.dart';

/// Abstract contract for detections repository
abstract class DetectionsRepository {
  Future<List<DetectionListItem>> getDetections();
  Future<DetectionDetail> getDetectionById(int id);
  Future<PredictResult> predictImage(String imagePath);
  Future<void> deleteDetection(int id);
}
