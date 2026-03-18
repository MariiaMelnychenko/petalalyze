import 'package:equatable/equatable.dart';
import 'package:petalalyze/features/flower/domain/entities/flower.dart';

/// Status of flowers catalog loading
enum FlowersCatalogStatus {
  initial,
  loading,
  success,
  failure,
}

/// State for flowers catalog screen
class FlowersCatalogState extends Equatable {
  const FlowersCatalogState({
    this.status = FlowersCatalogStatus.initial,
    this.flowers = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  final FlowersCatalogStatus status;
  final List<Flower> flowers;
  final String searchQuery;
  final String? errorMessage;

  /// Filtered flowers based on search query (client-side filter)
  List<Flower> get filteredFlowers {
    if (searchQuery.trim().isEmpty) return flowers;
    final query = searchQuery.trim().toLowerCase();
    return flowers.where((f) {
      final nameMatch = f.name.toLowerCase().contains(query);
      final latinMatch = f.latinName?.toLowerCase().contains(query) ?? false;
      return nameMatch || latinMatch;
    }).toList();
  }

  bool get isLoading => status == FlowersCatalogStatus.loading;
  bool get isFailure => status == FlowersCatalogStatus.failure;

  FlowersCatalogState copyWith({
    FlowersCatalogStatus? status,
    List<Flower>? flowers,
    String? searchQuery,
    String? errorMessage,
  }) {
    return FlowersCatalogState(
      status: status ?? this.status,
      flowers: flowers ?? this.flowers,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, flowers, searchQuery, errorMessage];
}
