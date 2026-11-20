import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../storage/auth_storage.dart';


class ApiClient {
  Future<Map<String, dynamic>> post(
      String url,
      Map<String, dynamic> body, {
        bool authRequired = false,
      }) async {
    final headers = {'Content-Type': 'application/json'};

    if (authRequired) {
      final token = await AuthStorage.getToken();
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http
        .post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    )
        .timeout(const Duration(seconds: 30)); // new

    debugPrint('POST $url -> ${response.statusCode} ${response.body}'); // new

    dynamic decoded; // new
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = null;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded is Map<String, dynamic> ? decoded : {};
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: (decoded is Map ? decoded['error'] : null) ??
          'Server error (${response.statusCode})',
    );
  }
  Future<dynamic> get(
      String url, {
        bool authRequired = false,
      }) async {
    final headers = {'Content-Type': 'application/json'};

    if (authRequired) {
      final token = await AuthStorage.getToken();
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(Uri.parse(url), headers: headers);

    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    final message = decoded is Map<String, dynamic>
        ? (decoded['error'] ?? 'Something went wrong.')
        : 'Something went wrong.';

    throw ApiException(statusCode: response.statusCode, message: message);
  }

  Future<dynamic> delete(
      String url, {
        bool authRequired = false,
      }) async {
    final headers = {'Content-Type': 'application/json'};

    if (authRequired) {
      final token = await AuthStorage.getToken();
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.delete(Uri.parse(url), headers: headers);

    final decoded = response.body.isEmpty ? {} : jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    final message = decoded is Map<String, dynamic>
        ? (decoded['error'] ?? 'Something went wrong.')
        : 'Something went wrong.';

    throw ApiException(statusCode: response.statusCode, message: message);
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException({required this.statusCode, required this.message});
}