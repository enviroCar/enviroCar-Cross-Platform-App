enum ExceptionType {
  requestCancelled,
  requestTimeout,
  noInternetConnection,
  timeout,
  unauthorisedRequest,
  badRequest,
  notFound,
  internalServerError,
  serviceUnavailable,
  unknownError,
  formatException
}

/// sends message based on the error type
extension ExceptionTypeExtension on ExceptionType {
  String message() {
    switch (this) {
      case ExceptionType.requestCancelled:
        return 'Sorry, the request was cancelled. Please try again.';
        break;
      case ExceptionType.requestTimeout:
        return 'Request timed out. Please try again.';
        break;
      case ExceptionType.noInternetConnection:
        return 'There is no Internet Connection. Please check your network.';
        break;
      case ExceptionType.timeout:
        return 'Timeout';
        break;
      case ExceptionType.unauthorisedRequest:
        return 'Wrong Credentials. Please try again with correct details.';
        break;
      case ExceptionType.notFound:
        return 'URL not found';
        break;
      case ExceptionType.internalServerError:
        return 'Internal server error. Please try again later.';
        break;
      case ExceptionType.serviceUnavailable:
        return 'Service unavailable';
        break;
      case ExceptionType.unknownError:
        return 'UnknownError';
        break;
      case ExceptionType.formatException:
        return 'Format exception';
        break;
      case ExceptionType.badRequest:
        return 'Bad request';
        break;

      default:
        return 'Something went wrong';
        break;
    }
  }
}
