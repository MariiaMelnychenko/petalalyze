import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/prediction_item.dart';
import '../../domain/usecases/get_detection_details_usecase.dart';
import 'detection_details_state.dart';

class DetectionDetailsCubit extends Cubit<DetectionDetailsState> {
  DetectionDetailsCubit(this._getDetectionDetailsUseCase)
      : super(const DetectionDetailsState());

  final GetDetectionDetailsUseCase _getDetectionDetailsUseCase;

  Future<void> load(int id) async {
    emit(state.copyWith(status: DetectionDetailsStatus.loading));
    try {
      final details = await _getDetectionDetailsUseCase(id);
      final filtered = _filter(details.detections, state.threshold);
      emit(
        DetectionDetailsState(
          status: DetectionDetailsStatus.success,
          id: details.id,
          imageUrl: details.imageUrl,
          resultImageUrl: details.resultImageUrl,
          fullDetections: details.detections,
          filteredDetections: filtered,
          threshold: state.threshold,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DetectionDetailsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void updateThreshold(double threshold) {
    emit(
      state.copyWith(
        threshold: threshold,
        filteredDetections: _filter(state.fullDetections, threshold),
      ),
    );
  }

  List<PredictionItem> _filter(List<PredictionItem> items, double threshold) {
    return items.where((d) => d.confidence >= threshold).toList();
  }
}
