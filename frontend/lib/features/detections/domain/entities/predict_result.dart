import 'prediction_item.dart';

/// Domain entity wrapping the full /predict response.
class PredictResult {
  const PredictResult({
    required this.detectionId,
    required this.resultImageUrl,
    required this.predictions,
  });

  final int detectionId;
  final String resultImageUrl;
  final List<PredictionItem> predictions;
}
