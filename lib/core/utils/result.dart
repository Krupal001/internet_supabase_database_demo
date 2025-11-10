import '../error/failures.dart';

/// A simple Result class to handle success and failure cases
/// This is easier to understand than Either from dartz
class Result<T> {
  final T? data;
  final Failure? failure;

  const Result._({this.data, this.failure});

  /// Creates a successful result with data
  factory Result.success(T data) {
    return Result._(data: data);
  }

  /// Creates a failed result with failure
  factory Result.failure(Failure failure) {
    return Result._(failure: failure);
  }

  /// Check if the result is successful
  bool get isSuccess => data != null && failure == null;

  /// Check if the result is a failure
  bool get isFailure => failure != null;

  /// Fold the result into a single value
  /// If success, calls onSuccess with data
  /// If failure, calls onFailure with failure
  R fold<R>({
    required R Function(Failure failure) onFailure,
    required R Function(T data) onSuccess,
  }) {
    if (isSuccess) {
      return onSuccess(data as T);
    } else {
      return onFailure(failure!);
    }
  }
}
