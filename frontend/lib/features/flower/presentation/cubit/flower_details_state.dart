import 'package:equatable/equatable.dart';

import '../../domain/entities/flower.dart';

enum FlowerDetailsStatus { initial, loading, success, failure }

class FlowerDetailsState extends Equatable {
  const FlowerDetailsState({
    this.status = FlowerDetailsStatus.initial,
    this.flower,
    this.errorMessage,
  });

  final FlowerDetailsStatus status;
  final Flower? flower;
  final String? errorMessage;

  bool get isLoading => status == FlowerDetailsStatus.loading;
  bool get isSuccess => status == FlowerDetailsStatus.success;
  bool get isFailure => status == FlowerDetailsStatus.failure;

  FlowerDetailsState copyWith({
    FlowerDetailsStatus? status,
    Flower? flower,
    String? errorMessage,
  }) {
    return FlowerDetailsState(
      status: status ?? this.status,
      flower: flower ?? this.flower,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, flower, errorMessage];
}
