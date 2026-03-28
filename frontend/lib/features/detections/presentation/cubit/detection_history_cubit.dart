import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/detection_event_bus.dart';
import '../../domain/usecases/delete_detection_usecase.dart';
import '../../domain/usecases/get_detection_history_usecase.dart';
import 'detection_history_state.dart';

class DetectionHistoryCubit extends Cubit<DetectionHistoryState> {
  DetectionHistoryCubit(
    this._getDetectionHistory,
    this._deleteDetection,
    this._eventBus,
  ) : super(const DetectionHistoryState()) {
    _sub = _eventBus.stream.listen((event) {
      if (!_selfFired) load();
      _selfFired = false;
    });
  }

  final GetDetectionHistoryUseCase _getDetectionHistory;
  final DeleteDetectionUseCase _deleteDetection;
  final DetectionEventBus _eventBus;
  late final StreamSubscription<DetectionEvent> _sub;
  bool _selfFired = false;

  Future<void> load() async {
    emit(state.copyWith(status: DetectionHistoryStatus.loading));
    try {
      final detections = await _getDetectionHistory();
      emit(DetectionHistoryState(
        status: DetectionHistoryStatus.success,
        detections: detections,
      ));
    } catch (_) {
      emit(state.copyWith(status: DetectionHistoryStatus.failure));
    }
  }

  Future<void> deleteDetection(int id) async {
    try {
      await _deleteDetection(id);
      final updated = state.detections.where((d) => d.id != id).toList();
      emit(state.copyWith(detections: updated));
      _selfFired = true;
      _eventBus.fire(DetectionEvent.deleted);
    } catch (_) {
      // Silently fail — item stays in list
    }
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
