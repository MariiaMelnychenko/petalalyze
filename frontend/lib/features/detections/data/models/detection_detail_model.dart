import '../../domain/entities/detection_detail.dart';
import 'prediction_item_model.dart';

class DetectionDetailModel extends DetectionDetail {
  DetectionDetailModel({
    required super.id,
    required super.imageUrl,
    required super.resultImageUrl,
    required super.detections,
  });

  factory DetectionDetailModel.fromJson(Map<String, dynamic> json) {
    final detectionsRaw = json['detections'] as List<dynamic>? ?? [];
    return DetectionDetailModel(
      id: json['id'] as int,
      imageUrl: json['image_url'] as String? ?? '',
      resultImageUrl: json['result_image_url'] as String? ?? '',
      detections: detectionsRaw
          .map(
            (e) => PredictionItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
