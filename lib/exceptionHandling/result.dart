import 'appException.dart';

/// object returned by http calls to tell whether the call
/// was successful or not

enum ResultStatus { success, error }

class Result {
  final ApplicationException exception;
  final dynamic value;
  final ResultStatus status;

  const Result.success(this.value)
      : status = ResultStatus.success,
        exception = null;
  const Result.failure(this.exception)
      : status = ResultStatus.error,
        value = null;
}
