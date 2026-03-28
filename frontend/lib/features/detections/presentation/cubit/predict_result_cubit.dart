import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/detection_event_bus.dart';
import '../../domain/entities/prediction_item.dart';
import '../../domain/usecases/predict_image_usecase.dart';
import 'predict_result_state.dart';

class PredictResultCubit extends Cubit<PredictResultState> {
  PredictResultCubit(this._predictImageUseCase, this._eventBus)
      : super(const PredictResultState());

  final PredictImageUseCase _predictImageUseCase;
  final DetectionEventBus _eventBus;

  Future<void> predict(String imagePath) async {
    emit(state.copyWith(
      status: PredictResultStatus.loading,
      imagePath: imagePath,
    ));

    try {
      final result = await _predictImageUseCase(imagePath);
      emit(PredictResultState(
        status: PredictResultStatus.success,
        fullDetections: result.predictions,
        filteredDetections: _filter(result.predictions, state.threshold),
        threshold: state.threshold,
        imagePath: imagePath,
        detectionId: result.detectionId,
        resultImageUrl: result.resultImageUrl,
      ));
      _eventBus.fire(DetectionEvent.added);
    } catch (e) {
      emit(state.copyWith(
        status: PredictResultStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void updateThreshold(double threshold) {
    emit(state.copyWith(
      threshold: threshold,
      filteredDetections: _filter(state.fullDetections, threshold),
    ));
  }

  List<PredictionItem> _filter(
    List<PredictionItem> items,
    double threshold,
  ) {
    return items.where((d) => d.confidence >= threshold).toList();
  }
}
