import 'package:flutter_bloc/flutter_bloc.dart';

import 'detection_history_state.dart';

class DetectionHistoryCubit extends Cubit<DetectionHistoryState> {
  DetectionHistoryCubit() : super(const DetectionHistoryState());

  Future<void> load() async {
    emit(state.copyWith(status: DetectionHistoryStatus.loading));
    try {
      // TODO: Replace with API call when backend is ready
      await Future<void>.delayed(const Duration(milliseconds: 500));
      const detections = <String>[];
      emit(const DetectionHistoryState(
        status: DetectionHistoryStatus.success,
        detections: [],
      ));
    } catch (_) {
      emit(state.copyWith(status: DetectionHistoryStatus.failure));
    }
  }
}
