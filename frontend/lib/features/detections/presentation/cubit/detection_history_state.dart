import 'package:equatable/equatable.dart';

enum DetectionHistoryStatus { initial, loading, success, failure }

class DetectionHistoryState extends Equatable {
  const DetectionHistoryState({
    this.status = DetectionHistoryStatus.initial,
    this.detections = const [],
  });

  final DetectionHistoryStatus status;
  final List<String> detections;

  bool get isLoading => status == DetectionHistoryStatus.loading;
  bool get isEmpty =>
      status == DetectionHistoryStatus.success && detections.isEmpty;
  bool get hasDetections => detections.isNotEmpty;

  DetectionHistoryState copyWith({
    DetectionHistoryStatus? status,
    List<String>? detections,
  }) {
    return DetectionHistoryState(
      status: status ?? this.status,
      detections: detections ?? this.detections,
    );
  }

  @override
  List<Object?> get props => [status, detections];
}
