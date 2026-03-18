import 'package:equatable/equatable.dart';

/// Base class for all failures in the app
abstract class Failure extends Equatable {
  const Failure([this.message]);

  final String? message;

  @override
  List<Object?> get props => [message];
}

/// Server/API failure
class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

/// Network failure (no connection, timeout)
class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

/// Cache/local storage failure
class CacheFailure extends Failure {
  const CacheFailure([super.message]);
}

/// Unknown/unexpected failure
class UnknownFailure extends Failure {
  const UnknownFailure([super.message]);
}
