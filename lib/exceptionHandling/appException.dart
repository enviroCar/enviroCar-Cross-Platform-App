import 'exceptionType.dart';

/// class to identify the error type and show an appropriate message
/// corresponding to that error type
class ApplicationException implements Exception {
  ExceptionType? type;

  ApplicationException([this.type]);

  String? getErrorMessage() => type?.message();
}
