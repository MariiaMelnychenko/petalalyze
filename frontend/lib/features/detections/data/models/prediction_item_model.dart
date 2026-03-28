import '../../domain/entities/prediction_item.dart';

/// DTO for a single prediction result from POST /predict.
class PredictionItemModel extends PredictionItem {
  PredictionItemModel({
    required super.bbox,
    required super.className,
    required super.confidence,
    super.yoloConfidence,
    super.ensembleConfidence,
    super.cropUrl,
  });

  factory PredictionItemModel.fromJson(Map<String, dynamic> json) {
    final bboxRaw = json['bbox'] as List<dynamic>? ?? [];
    return PredictionItemModel(
      bbox: bboxRaw.map((e) => (e as num).toDouble()).toList(),
      className: json['class_name'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      yoloConfidence: (json['yolo_confidence'] as num?)?.toDouble(),
      ensembleConfidence: (json['ensemble_confidence'] as num?)?.toDouble(),
      cropUrl: json['crop_url'] as String?,
    );
  }
}
