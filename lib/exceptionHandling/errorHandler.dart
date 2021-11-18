import 'dart:io';
import 'package:dio/dio.dart' as dio;

import 'appException.dart';
import 'exceptionType.dart';

/// identifies the error and return an appropriate error type
///
/// It takes the dio error as a parameter and using it identifies
/// the kind of error that might have occurred and corresponding to
/// that error, it returns an application exception which contains
/// a message to show to the user
ApplicationException handleException(dynamic error) {
  if (error is Exception) {
    try {
      ApplicationException exception;
      if (error is dio.DioError) {
        switch (error.type) {
          case dio.DioErrorType.connectTimeout:
            exception = ApplicationException(ExceptionType.requestTimeout);
            break;
          case dio.DioErrorType.sendTimeout:
            exception = ApplicationException(ExceptionType.timeout);
            break;
          case dio.DioErrorType.receiveTimeout:
            exception = ApplicationException(ExceptionType.timeout);
            break;
          case dio.DioErrorType.response:
            switch (error.response.statusCode) {
              case 400:
                exception = ApplicationException(ExceptionType.badRequest);
                break;
              case 401:
                exception =
                    ApplicationException(ExceptionType.unauthorisedRequest);
                break;
              case 403:
                exception =
                    ApplicationException(ExceptionType.unauthorisedRequest);
                break;
              case 404:
                exception = ApplicationException(ExceptionType.notFound);
                break;
              case 409:
                exception = ApplicationException(ExceptionType.unknownError);
                break;
              case 408:
                exception = ApplicationException(ExceptionType.requestTimeout);
                break;
              case 500:
                exception =
                    ApplicationException(ExceptionType.internalServerError);
                break;
              case 503:
                exception =
                    ApplicationException(ExceptionType.serviceUnavailable);
                break;
              default:
                exception = ApplicationException(ExceptionType.unknownError);
            }
            break;
          case dio.DioErrorType.cancel:
            exception = ApplicationException(ExceptionType.requestCancelled);
            break;
          case dio.DioErrorType.other:
            exception =
                ApplicationException(ExceptionType.noInternetConnection);
            break;
        }
      } else if (error is SocketException) {
        exception = ApplicationException(ExceptionType.noInternetConnection);
      } else {
        exception = ApplicationException(ExceptionType.unknownError);
      }
      return exception;
    } on FormatException {
      return ApplicationException(ExceptionType.formatException);
    } catch (_) {
      return ApplicationException(ExceptionType.unknownError);
    }
  } else {
    return ApplicationException(ExceptionType.unknownError);
  }
}
