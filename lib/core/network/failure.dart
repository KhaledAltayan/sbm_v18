import 'package:dio/dio.dart';

class Failure {
  final int? statusCode;
  final String message;
  Failure({this.statusCode, required this.message});
  factory Failure.handleError(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.badCertificate:
          return Failure(message: 'Connection Timeout, please try again');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final responseData = error.response?.data;
          final errorMessage = responseData?['message'] ?? 'Unknown error';
          if (statusCode != null && statusCode >= 400 && statusCode < 500) {
            return Failure(statusCode: statusCode, message: errorMessage);
          } else if (statusCode != null && statusCode >= 500) {
            return Failure(statusCode: statusCode, message: 'Server Error');
          } else {
            return Failure(message: 'Error happened, Try again');
          }
        case DioExceptionType.cancel:
          return Failure(message: 'User cancelled the request');
        case DioExceptionType.connectionError:
          return Failure(message: 'Check Your Internet');
        case DioExceptionType.unknown:
          return Failure(message: 'An error happened, please try again');
        // default:
        //   return Failure(message: 'Unknown error occurred');F
      }
    } else if (error is Exception) {
      return Failure(message: 'Error happened, please try again');
    } else if (error is Error) {
      return Failure(message: 'Unexpected error: ${error.toString()}');
    }
    return Failure(message: 'An unknown error occurred');
  }
}
