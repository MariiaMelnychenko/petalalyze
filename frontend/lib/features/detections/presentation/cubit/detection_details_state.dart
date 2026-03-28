import 'package:equatable/equatable.dart';

import '../../domain/entities/prediction_item.dart';

enum DetectionDetailsStatus { initial, loading, success, failure }

class DetectionDetailsState extends Equatable {
  const DetectionDetailsState({
    this.status = DetectionDetailsStatus.initial,
    this.id,
    this.imageUrl,
    this.resultImageUrl,
    this.fullDetections = const [],
    this.filteredDetections = const [],
    this.threshold = 0.5,
    this.errorMessage,
  });

  final DetectionDetailsStatus status;
  final int? id;
  final String? imageUrl;
  final String? resultImageUrl;
  final List<PredictionItem> fullDetections;
  final List<PredictionItem> filteredDetections;
  final double threshold;
  final String? errorMessage;

  bool get isLoading => status == DetectionDetailsStatus.loading;
  bool get isSuccess => status == DetectionDetailsStatus.success;
  bool get isFailure => status == DetectionDetailsStatus.failure;
  bool get hasResults => filteredDetections.isNotEmpty;

  DetectionDetailsState copyWith({
    DetectionDetailsStatus? status,
    int? id,
    String? imageUrl,
    String? resultImageUrl,
    List<PredictionItem>? fullDetections,
    List<PredictionItem>? filteredDetections,
    double? threshold,
    String? errorMessage,
  }) {
    return DetectionDetailsState(
      status: status ?? this.status,
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      resultImageUrl: resultImageUrl ?? this.resultImageUrl,
      fullDetections: fullDetections ?? this.fullDetections,
      filteredDetections: filteredDetections ?? this.filteredDetections,
      threshold: threshold ?? this.threshold,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        id,
        imageUrl,
        resultImageUrl,
        fullDetections,
        filteredDetections,
        threshold,
        errorMessage,
      ];
}
