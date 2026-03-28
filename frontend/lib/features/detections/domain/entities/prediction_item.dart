/// Domain entity representing a single prediction result from the ensemble pipeline.
class PredictionItem {
  const PredictionItem({
    required this.bbox,
    required this.className,
    required this.confidence,
    this.yoloConfidence,
    this.ensembleConfidence,
    this.cropUrl,
  });

  final List<double> bbox;
  final String className;
  final double confidence;
  final double? yoloConfidence;
  final double? ensembleConfidence;
  final String? cropUrl;
}
