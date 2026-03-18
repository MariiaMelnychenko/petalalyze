import '../entities/detection_list_item.dart';

/// Abstract contract for detections repository
abstract class DetectionsRepository {
  Future<List<DetectionListItem>> getDetections();
}
