import 'prediction_item.dart';

class DetectionDetail {
  const DetectionDetail({
    required this.id,
    required this.imageUrl,
    required this.resultImageUrl,
    required this.detections,
  });

  final int id;
  final String imageUrl;
  final String resultImageUrl;
  final List<PredictionItem> detections;
}
