import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/either.dart';
import '../../domain/repositories/flowers_repository.dart';
import 'flower_details_state.dart';

class FlowerDetailsCubit extends Cubit<FlowerDetailsState> {
  FlowerDetailsCubit(this._repository) : super(const FlowerDetailsState());

  final FlowersRepository _repository;

  Future<void> loadFlower(int id) async {
    emit(state.copyWith(status: FlowerDetailsStatus.loading, errorMessage: null));

    final result = await _repository.getFlowerById(id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: FlowerDetailsStatus.failure,
        errorMessage: failure.message ?? 'Unknown error',
      )),
      (flower) => emit(state.copyWith(
        status: FlowerDetailsStatus.success,
        flower: flower,
      )),
    );
  }
}
