class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, "Respon Server Error:\n");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input:\n");
}

class ErrorNoCodeException extends AppException {
  ErrorNoCodeException([String? message]) : super(message, "Error peer:\n");
}

class NoServerException extends AppException {
  NoServerException([int? status]) : super(status, '');
}

class NoInternetException extends AppException {
  NoInternetException([String? message])
      : super(message, 'Server Unreachable:\n');
}
