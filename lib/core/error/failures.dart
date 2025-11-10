import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Server failure (API/Database errors)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Cache failure (Local storage errors)
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Network failure (Connection errors)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Validation failure (Input validation errors)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
