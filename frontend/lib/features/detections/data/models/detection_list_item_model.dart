import 'package:petalalyze/features/detections/domain/entities/detection_list_item.dart';

/// DTO for detection list item from API
class DetectionListItemModel extends DetectionListItem {
  DetectionListItemModel({
    required super.id,
    required super.imageUrl,
    required super.resultImageUrl,
    required super.detectionsCount,
    required super.createdAt,
  });

  factory DetectionListItemModel.fromJson(Map<String, dynamic> json) {
    return DetectionListItemModel(
      id: json['id'] as int,
      imageUrl: json['image_url'] as String,
      resultImageUrl: json['result_image_url'] as String? ?? '',
      detectionsCount: json['detections_count'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
