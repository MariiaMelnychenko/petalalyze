import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../detections/domain/usecases/get_detection_history_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getDetectionHistory) : super(const HomeState());

  final GetDetectionHistoryUseCase _getDetectionHistory;

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
}
