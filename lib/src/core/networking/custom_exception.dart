// ignore_for_file: constant_identifier_names
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

// Models
import 'api_response.dart';

/// An enum that holds names for our custom exceptions.
enum _ExceptionType {
  /// The exception for an expired bearer token.
  TokenExpiredException,

  /// The exception for a prematurely cancelled request.
  CancelException,

  /// The exception for a failed connection attempt.
  ConnectTimeoutException,

  /// The exception for failing to send a request.
  SendTimeoutException,

  /// The exception for failing to receive a response.
  ReceiveTimeoutException,

  /// The exception for no internet connectivity.
  SocketException,

  /// A better name for the socket exception.
  FetchDataException,

  /// The exception for an incorrect parameter in a request/response.
  FormatException,

  /// The exception for an unknown type of failure.
  UnrecognizedException,

  /// The exception for an unknown exception from the api.
  ApiException,

  /// The exception for any parsing failure encountered during
  /// serialization/deserialization of a request.
  SerializationException,
}

class CustomException implements Exception {
  final String name, message;
  final _ExceptionType exceptionType;

  CustomException({
    String? code,
    required this.message,
    required this.exceptionType,
  }) : name = code ?? exceptionType.name;

  factory CustomException.fromDioException(Exception error) {
    try {
      if (error is DioError) {
        switch (error.type) {
          case DioErrorType.cancel:
            return CustomException(
              exceptionType: _ExceptionType.CancelException,
              message: 'Request cancelled prematurely',
            );
          case DioErrorType.connectTimeout:
            return CustomException(
              exceptionType: _ExceptionType.ConnectTimeoutException,
              message: 'Connection not established',
            );
          case DioErrorType.sendTimeout:
            return CustomException(
              exceptionType: _ExceptionType.SendTimeoutException,
              message: 'Failed to send',
            );
          case DioErrorType.receiveTimeout:
            return CustomException(
              exceptionType: _ExceptionType.ReceiveTimeoutException,
              message: 'Failed to receive',
            );
          case DioErrorType.response:
          case DioErrorType.other:
            if (error.message.contains(_ExceptionType.SocketException.name)) {
              return CustomException(
                exceptionType: _ExceptionType.FetchDataException,
                message: 'No internet connectivity',
              );
            }
            String name, message;
            if (error.response?.data is ApiResponse) {
              final res = error.response?.data as ApiResponse;
              name = res.headers.code!;
              message = res.headers.message;
            } else {
              // TODO(arafaysaleem): remove else clause if ApiResponse
              name = error.response?.data['headers']['code'] as String;
              message = error.response?.data['headers']['message'] as String;
            }
            if (name == _ExceptionType.TokenExpiredException.name) {
              return CustomException(
                exceptionType: _ExceptionType.TokenExpiredException,
                message: message,
              );
            }
            return CustomException(
              exceptionType: _ExceptionType.ApiException,
              message: message,
            );
        }
      } else {
        return CustomException(
          exceptionType: _ExceptionType.UnrecognizedException,
          message: 'Error unrecognized',
        );
      }
    } on FormatException catch (e) {
      return CustomException(
        exceptionType: _ExceptionType.FormatException,
        message: e.message,
      );
    } on Exception catch (_) {
      return CustomException(
        exceptionType: _ExceptionType.UnrecognizedException,
        message: 'Error unrecognized',
      );
    }
  }

  factory CustomException.fromParsingException(Exception error) {
    // TODO(arafaysaleem): add logging to print stack trace
    debugPrint('$error');
    return CustomException(
      exceptionType: _ExceptionType.SerializationException,
      message: 'Failed to parse network response to model or vice versa',
    );
  }
}
