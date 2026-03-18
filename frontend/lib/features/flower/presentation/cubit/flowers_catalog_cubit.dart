import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petalalyze/features/flower/domain/repositories/flowers_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import 'flowers_catalog_state.dart';

/// Cubit for flowers catalog - loads from API, supports search
class FlowersCatalogCubit extends Cubit<FlowersCatalogState> {
  FlowersCatalogCubit(this._repository) : super(const FlowersCatalogState());

  final FlowersRepository _repository;

  /// Load flowers from backend
  Future<void> loadFlowers() async {
    emit(state.copyWith(status: FlowersCatalogStatus.loading, errorMessage: null));

    final result = await _repository.getFlowers();

    result.fold(
      (failure) => emit(state.copyWith(
        status: FlowersCatalogStatus.failure,
        errorMessage: _mapFailureToMessage(failure),
      )),
      (flowers) => emit(state.copyWith(
        status: FlowersCatalogStatus.success,
        flowers: flowers,
      )),
    );
  }

  /// Update search query (filters client-side)
  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message ?? 'Unknown error';
  }
}
