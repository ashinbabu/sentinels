import 'dart:async';
import 'dart:convert';

import 'package:busco/utils/constants.dart';
import 'package:http/http.dart' as http;

class ApiResponse {
  final bool success;
  final Map<String, dynamic> body;
  final String? error;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    required this.body,
    this.error,
    this.statusCode,
  });
}

class ApiClient {
  static const Duration _timeout = Duration(seconds: 15);

  static Uri _uri(String path, [Map<String, dynamic>? query]) {
    return Uri.parse('$baseUrl$path').replace(
      queryParameters: query?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  static Map<String, String> _headers({String? authToken}) {
    return {
      if (authToken != null && authToken.trim().isNotEmpty)
        'Authorization': 'Bearer $authToken',
    };
  }

  static Future<ApiResponse> get(
    String path, {
    Map<String, dynamic>? query,
    String? authToken,
  }) async {
    try {
      final response = await http
          .get(
            _uri(path, query),
            headers: _headers(authToken: authToken),
          )
          .timeout(_timeout);
      return _decode(response);
    } on TimeoutException {
      return const ApiResponse(
        success: false,
        body: {},
        error: 'Request timed out',
      );
    } catch (_) {
      return const ApiResponse(
        success: false,
        body: {},
        error: 'Network error',
      );
    }
  }

  static Future<ApiResponse> postForm(
    String path, {
    required Map<String, dynamic> fields,
    String? authToken,
  }) async {
    try {
      final request = http.MultipartRequest('POST', _uri(path))
        ..headers.addAll(_headers(authToken: authToken))
        ..fields.addAll(
          fields.map((key, value) => MapEntry(key, value.toString())),
        );
      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);
      return _decode(response);
    } on TimeoutException {
      return const ApiResponse(
        success: false,
        body: {},
        error: 'Request timed out',
      );
    } catch (_) {
      return const ApiResponse(
        success: false,
        body: {},
        error: 'Network error',
      );
    }
  }

  static ApiResponse _decode(http.Response response) {
    Map<String, dynamic> body = {};
    try {
      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic>) {
        body = decoded;
      }
    } catch (_) {}

    final status = body['status']?.toString().toLowerCase();
    final success = response.statusCode >= 200 &&
        response.statusCode < 300 &&
        status != 'failure';

    String? error;
    if (!success) {
      final dynamic err = body['error'] ?? body['message'];
      error = err == null || err.toString().trim().isEmpty
          ? 'Request failed (${response.statusCode})'
          : err.toString();
    }

    return ApiResponse(
      success: success,
      body: body,
      error: error,
      statusCode: response.statusCode,
    );
  }
}
