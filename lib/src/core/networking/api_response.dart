import 'dart:convert';

// Helpers
import '../../helpers/typedefs.dart';

class ApiResponse<T> {
  final T body;
  final _ResponseHeaders headers;

  const ApiResponse._({
    required this.body,
    required this.headers,
  });

  bool get isSuccess => headers.error == 0;

  factory ApiResponse.fromJson(JSON json) {
    return ApiResponse._(
      body: json['body'] as T,
      headers: _ResponseHeaders.fromJson(json['headers'] as JSON),
    );
  }

  factory ApiResponse.fromStringResponse(String response) {
    return ApiResponse.fromJson(json.decode(response) as JSON);
  }
}

class _ResponseHeaders {
  final String message;
  final int error;
  final String? code;
  final List<Object?>? data;

  const _ResponseHeaders._({
    this.code,
    this.data,
    required this.message,
    required this.error,
  }) : assert(
          error == 0 || code != null,
          'No error code provided for a failing response',
        );

  factory _ResponseHeaders.fromJson(JSON headers) {
    return _ResponseHeaders._(
      message: headers['message'] as String,
      error: headers['error'] as int,
      code: headers.containsKey('code') ? headers['code'] as String : null,
      data:
          headers.containsKey('data',) ? headers['data'] as List<Object?> : null,
    );
  }
}
