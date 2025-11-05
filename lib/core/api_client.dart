import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

/// Central HTTP client for the app.
/// Update [ApiConfig.baseUrl] once backend URL is known.
class ApiConfig {
  // For Android emulator, use 10.0.2.2 instead of localhost
  // For iOS simulator, use localhost
  // For physical device, use your computer's IP address (e.g., 192.168.x.x)
  static String get baseUrl {
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty && envUrl != 'YOUR_BACKEND_BASE_URL') {
      return envUrl;
    }
    
    // Default to localhost - adjust port as needed
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000'; // Android emulator
    } else if (Platform.isIOS) {
      return 'http://localhost:8000'; // iOS simulator
    } else {
      return 'http://localhost:8000'; // Other platforms
    }
  }

  // Common headers (extend as needed)
  static Map<String, String> defaultHeaders({String? token}) => {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };
}

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _buildUri(String path, [Map<String, dynamic>? query]) {
    final uri = Uri.parse(ApiConfig.baseUrl).replace(
      path: Uri.parse(ApiConfig.baseUrl).path + path,
      queryParameters: query?.map((k, v) => MapEntry(k, '$v')),
    );
    return uri;
  }

  Future<http.Response> get(
    String path, {
    Map<String, dynamic>? query,
    String? token,
  }) async {
    final uri = _buildUri(path, query);
    if (kDebugMode) debugPrint('[GET] $uri');
    return _client.get(uri, headers: ApiConfig.defaultHeaders(token: token));
  }

  Future<http.Response> post(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    final uri = _buildUri(path, query);
    if (kDebugMode) debugPrint('[POST] $uri body=$body');
    return _client.post(
      uri,
      headers: ApiConfig.defaultHeaders(token: token),
      body: body is String ? body : jsonEncode(body ?? {}),
    );
  }

  Future<http.Response> put(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    final uri = _buildUri(path, query);
    if (kDebugMode) debugPrint('[PUT] $uri body=$body');
    return _client.put(
      uri,
      headers: ApiConfig.defaultHeaders(token: token),
      body: body is String ? body : jsonEncode(body ?? {}),
    );
  }

  Future<http.Response> delete(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    final uri = _buildUri(path, query);
    if (kDebugMode) debugPrint('[DELETE] $uri body=$body');
    return _client.delete(
      uri,
      headers: ApiConfig.defaultHeaders(token: token),
      body: body == null
          ? null
          : (body is String ? body : jsonEncode(body)),
    );
  }
}



