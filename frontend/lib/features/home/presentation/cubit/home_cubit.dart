import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/detection_event_bus.dart';
import '../../../detections/domain/usecases/get_detection_history_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getDetectionHistory, this._eventBus)
      : super(const HomeState()) {
    _sub = _eventBus.stream.listen((_) => loadDetectionHistory());
  }

  final GetDetectionHistoryUseCase _getDetectionHistory;
  final DetectionEventBus _eventBus;
  late final StreamSubscription<DetectionEvent> _sub;

  Future<void> loadDetectionHistory() async {
    emit(state.copyWith(historyStatus: DetectionHistoryStatus.loading));
    try {
      final detections = await _getDetectionHistory();
      emit(HomeState(
        historyStatus: DetectionHistoryStatus.success,
        detections: detections,
      ));
    } catch (_) {
      emit(state.copyWith(historyStatus: DetectionHistoryStatus.failure));
    }
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
