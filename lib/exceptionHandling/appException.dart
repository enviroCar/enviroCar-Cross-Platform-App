import 'exceptionType.dart';

// class to identify the error type and show an appropriate message
// corresponding to that error type
class ApplicationException implements Exception {
  final ExceptionType _type;

  ApplicationException([this._type]);

  String getErrorMessage() => _type.message();
}
