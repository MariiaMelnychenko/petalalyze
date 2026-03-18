import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_detection_history_usecase.dart';
import 'detection_history_state.dart';

class DetectionHistoryCubit extends Cubit<DetectionHistoryState> {
  DetectionHistoryCubit(this._getDetectionHistory)
      : super(const DetectionHistoryState());

  final GetDetectionHistoryUseCase _getDetectionHistory;

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
}
