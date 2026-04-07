import 'dart:convert';
import 'package:http/http.dart' as http;
import '../errors/exceptions.dart';

/// HTTP client wrapper for making API calls
class HttpClient {
  final http.Client _client;

  HttpClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(String url) async {
    try {
      final response = await _client.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw ServerException(
          message: 'Failed to load data from server',
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw const ServerException(
        message: 'Network error. Please check your connection.',
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
