/// Functional programming Either type for error handling
/// Left = Failure, Right = Success
sealed class Either<L, R> {
  const Either();
}

class Left<L, R> extends Either<L, R> {
  const Left(this.value);
  final L value;
}

class Right<L, R> extends Either<L, R> {
  const Right(this.value);
  final R value;
}

/// Extension for mapping Either
extension EitherExtension<L, R> on Either<L, R> {
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return switch (this) {
      Left(value: final v) => onLeft(v),
      Right(value: final v) => onRight(v),
    };
  }

  R? get rightOrNull => fold((_) => null, (r) => r);
  L? get leftOrNull => fold((l) => l, (_) => null);
}
