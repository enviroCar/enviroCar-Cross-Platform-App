import 'appException.dart';

/// object returned by http call
///
/// it shows the status of the call made and has a value attribute
/// that can be used to store the data received from the response
/// and later use in the UI

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
