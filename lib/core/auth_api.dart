import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

/// Authentication API service
/// Handles all authentication-related API calls
class AuthApi {
  final ApiClient _apiClient;

  AuthApi({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Send OTP to phone number
  /// Returns Map with 'success' boolean and 'userId' string
  Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      final response = await _apiClient.post(
        '/api/auth/send-otp',
        body: {
          'phone': phone,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final success = responseData['success'] ?? false;
        final userId = responseData['data']?['userId'];

        return {
          'success': success,
          'userId': userId,
          'message': responseData['message'],
        };
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? errorData['error'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Login with phone, email, and password
  /// Returns Map with 'success' boolean and 'token' string
  Future<Map<String, dynamic>> login({
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/api/login', // Update this path to match your API endpoint
        body: {
          'phone': phone,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'] ?? responseData['access_token'];
        final success = token != null;

        return {
          'success': success,
          'token': token,
          'user': responseData['user'] ?? responseData['data'],
          'message': responseData['message'],
        };
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? errorData['error'] ?? 'Login failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Verify OTP
  /// Returns Map with 'success' boolean and 'token' string (if verification successful)
  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
    String? userId,
  }) async {
    try {
      final response = await _apiClient.post(
        '/api/auth/verify-otp', // Update this path to match your API endpoint
        body: {
          'phone': phone,
          'otp': otp,
          if (userId != null) 'userId': userId,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final success = responseData['success'] ?? false;
        final token = responseData['token'] ?? responseData['access_token'];

        return {
          'success': success,
          'token': token,
          'user': responseData['user'] ?? responseData['data'],
          'message': responseData['message'],
        };
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? errorData['error'] ?? 'OTP verification failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Set password after OTP verification
  /// Returns Map with 'success' boolean and 'token' string
  Future<Map<String, dynamic>> setPassword({
    required String userId,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/api/auth/set-password', // Update this path to match your API endpoint
        body: {
          'userId': userId,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final success = responseData['success'] ?? false;
        final token = responseData['token'] ?? responseData['access_token'];

        return {
          'success': success,
          'token': token,
          'user': responseData['user'] ?? responseData['data'],
          'message': responseData['message'],
        };
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? errorData['error'] ?? 'Failed to set password');
      }
    } catch (e) {
      rethrow;
    }
  }
}

