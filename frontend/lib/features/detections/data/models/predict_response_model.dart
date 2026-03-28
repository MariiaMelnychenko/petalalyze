import '../../domain/entities/predict_result.dart';
import 'prediction_item_model.dart';

/// DTO for the full POST /predict response.
class PredictResponseModel extends PredictResult {
  PredictResponseModel({
    required super.detectionId,
    required super.resultImageUrl,
    required super.predictions,
  });

  factory PredictResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['predictions'] as List<dynamic>? ?? [];
    return PredictResponseModel(
      detectionId: json['detection_id'] as int,
      resultImageUrl: json['result_image_url'] as String,
      predictions: rawList
          .map((e) =>
              PredictionItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
