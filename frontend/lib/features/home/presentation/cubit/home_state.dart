import 'package:equatable/equatable.dart';

import '../../../detections/domain/entities/detection_list_item.dart';

enum DetectionHistoryStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.historyStatus = DetectionHistoryStatus.initial,
    this.detections = const [],
  });

  final DetectionHistoryStatus historyStatus;
  final List<DetectionListItem> detections;

  bool get isHistoryLoading => historyStatus == DetectionHistoryStatus.loading;
  bool get isHistoryEmpty =>
      historyStatus == DetectionHistoryStatus.success && detections.isEmpty;
  bool get isHistoryFailure => historyStatus == DetectionHistoryStatus.failure;

  HomeState copyWith({
    DetectionHistoryStatus? historyStatus,
    List<DetectionListItem>? detections,
  }) {
    return HomeState(
      historyStatus: historyStatus ?? this.historyStatus,
      detections: detections ?? this.detections,
    );
  }

  @override
  List<Object?> get props => [historyStatus, detections];
}
