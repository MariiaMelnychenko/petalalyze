import 'package:equatable/equatable.dart';

import '../../domain/entities/prediction_item.dart';

enum PredictResultStatus { initial, loading, success, failure }

class PredictResultState extends Equatable {
  const PredictResultState({
    this.status = PredictResultStatus.initial,
    this.fullDetections = const [],
    this.filteredDetections = const [],
    this.threshold = 0.5,
    this.imagePath,
    this.errorMessage,
    this.detectionId,
    this.resultImageUrl,
  });

  final PredictResultStatus status;
  final List<PredictionItem> fullDetections;
  final List<PredictionItem> filteredDetections;
  final double threshold;
  final String? imagePath;
  final String? errorMessage;
  final int? detectionId;
  final String? resultImageUrl;

  bool get isLoading => status == PredictResultStatus.loading;
  bool get isSuccess => status == PredictResultStatus.success;
  bool get isFailure => status == PredictResultStatus.failure;
  bool get hasResults => filteredDetections.isNotEmpty;

  PredictResultState copyWith({
    PredictResultStatus? status,
    List<PredictionItem>? fullDetections,
    List<PredictionItem>? filteredDetections,
    double? threshold,
    String? imagePath,
    String? errorMessage,
    int? detectionId,
    String? resultImageUrl,
  }) {
    return PredictResultState(
      status: status ?? this.status,
      fullDetections: fullDetections ?? this.fullDetections,
      filteredDetections: filteredDetections ?? this.filteredDetections,
      threshold: threshold ?? this.threshold,
      imagePath: imagePath ?? this.imagePath,
      errorMessage: errorMessage ?? this.errorMessage,
      detectionId: detectionId ?? this.detectionId,
      resultImageUrl: resultImageUrl ?? this.resultImageUrl,
    );
  }

  @override
  List<Object?> get props => [
        status,
        fullDetections,
        filteredDetections,
        threshold,
        imagePath,
        errorMessage,
        detectionId,
        resultImageUrl,
      ];
}
