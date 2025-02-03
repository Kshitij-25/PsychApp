import 'dart:io';

import 'package:dio/dio.dart';

class DioErrorHandler {
  String? errorMessage;

  DioErrorHandler(DioException dioError) {
    setErrorMessage(dioError);
  }

  void setErrorMessage(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = "Connection timed out. Please check your internet connection and try again.";
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = "Request send timeout. Please try again.";
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = "Response receive timeout. Please try again.";
        break;
      case DioExceptionType.badResponse:
        errorMessage = _httpErrorMessages[dioError.response?.statusCode] ?? "An unexpected error occurred. Please try again.";
        break;
      case DioExceptionType.cancel:
        errorMessage = "Request to the server was cancelled. Please try again.";
        break;
      case DioExceptionType.badCertificate:
        errorMessage = "Invalid certificate received from the server. Please check your network security settings.";
        break;
      case DioExceptionType.connectionError:
        errorMessage = "Connection error. Please check your internet connection and try again.";
        break;
      case DioExceptionType.unknown:
        errorMessage = dioError.error is SocketException
            ? "Network error. Please check your connection and try again."
            : "An unexpected error occurred. Please try again.";
        break;
    }
  }

  static const Map<int, String> _httpErrorMessages = {
    200: "Success! Your request was processed successfully.",
    400: "Oops! Something went wrong with your request. Please check your input and try again.",
    401: "Whoops! You are unauthorized. Please ensure your API key is correct.",
    429: "You're sending too many requests. Please wait a moment and try again.",
    500: "Something went wrong on our end. Please try again later.",
  };

  static const Map<String, String> _errorCodesMessages = {
    "apiKeyDisabled": "Your API key has been disabled. Please contact support.",
    "apiKeyExhausted": "Your API key has no remaining requests. Try again later.",
    "apiKeyInvalid": "Your API key is invalid. Please verify the key and try again.",
    "apiKeyMissing": "API key is missing. Please provide a valid key.",
    "parameterInvalid": "A parameter in your request is invalid. Check the message property for more details.",
    "parametersMissing": "Required parameters are missing from your request. Check the message property for more details.",
    "rateLimited": "You’ve been rate-limited. Please wait before making additional requests.",
    "sourcesTooMany": "You have requested too many sources. Try splitting your request into smaller ones.",
    "sourceDoesNotExist": "The requested source does not exist. Please check the source name.",
    "unexpectedError": "An unexpected error occurred on our side. Please try again shortly.",
  };

  String? getErrorMessageFromCode(String? errorCode) {
    return _errorCodesMessages[errorCode] ?? "An unknown error occurred.";
  }
}
