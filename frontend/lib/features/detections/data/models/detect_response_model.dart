/// DTO for POST /detect API response
class DetectResponseModel {
  DetectResponseModel({
    required this.detectionId,
    required this.resultImageUrl,
    required this.detections,
  });

  final int detectionId;
  final String resultImageUrl;
  final List<DetectItemModel> detections;

  factory DetectResponseModel.fromJson(Map<String, dynamic> json) {
    final detectionsList = json['detections'] as List<dynamic>? ?? [];
    return DetectResponseModel(
      detectionId: json['detection_id'] as int,
      resultImageUrl: json['result_image_url'] as String,
      detections: detectionsList
          .map((e) => DetectItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DetectItemModel {
  DetectItemModel({
    required this.flowerId,
    required this.className,
    required this.confidence,
    required this.bbox,
    this.cropUrl,
  });

  final int flowerId;
  final String className;
  final double confidence;
  final List<double> bbox;
  final String? cropUrl;

  factory DetectItemModel.fromJson(Map<String, dynamic> json) {
    final bboxList = json['bbox'] as List<dynamic>? ?? [];
    return DetectItemModel(
      flowerId: json['flower_id'] as int,
      className: json['class_name'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      bbox: bboxList.map((e) => (e as num).toDouble()).toList(),
      cropUrl: json['crop_url'] as String?,
    );
  }
}
