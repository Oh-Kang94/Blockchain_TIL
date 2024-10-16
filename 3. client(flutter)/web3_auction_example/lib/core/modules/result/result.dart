import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
sealed class Result<T> with _$Result {
  factory Result.success(T value) = Success;
  factory Result.failure(Exception error) = Failure;
}

extension ResultX<T> on Result<T> {
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Exception e) onFailure,
  }) {
    return when(
      success: (value) => onSuccess(value),
      failure: (error) => onFailure(error),
    );
  }

  T getOrThrow() {
    return this is Success
        ? (this as Success).value
        : throw (this as Failure).error;
  }
}
