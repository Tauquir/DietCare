import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';

class AuthService {
  static String get baseUrl => ApiConfig.baseUrl;

  /// Sends OTP to the provided phone number
  /// Returns a map with 'success', 'message', and 'data' containing userId and otp
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      final url = '$baseUrl/auth/send-otp';
      final headers = {
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'phone': phone,
      });

      print('📤 API REQUEST: POST $url');
      print('📤 Headers: $headers');
      print('📤 Body: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('📥 API RESPONSE: ${response.statusCode}');
      print('📥 Headers: ${response.headers}');
      print('📥 Body: ${response.body}');

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      } else {
        // Handle error response
        throw Exception(responseData['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      print('❌ API ERROR (sendOtp): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Resends OTP to the provided phone number
  /// Returns a map with 'success', 'message', and 'data' containing userId and otp
  static Future<Map<String, dynamic>> resendOtp(String phone) async {
    try {
      final url = '$baseUrl/auth/resend-otp';
      final headers = {
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'phone': phone,
      });

      print('📤 API REQUEST: POST $url');
      print('📤 Headers: $headers');
      print('📤 Body: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('📥 API RESPONSE: ${response.statusCode}');
      print('📥 Headers: ${response.headers}');
      print('📥 Body: ${response.body}');

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      } else {
        // Handle error response
        throw Exception(responseData['message'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      print('❌ API ERROR (resendOtp): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Verifies OTP for the provided phone number
  /// Returns a map with 'success', 'message', and 'data' containing userId
  static Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    try {
      final url = '$baseUrl/auth/verify-otp';
      final headers = {
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'phone': phone,
        'otp': otp,
      });

      print('📤 API REQUEST: POST $url');
      print('📤 Headers: $headers');
      print('📤 Body: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('📥 API RESPONSE: ${response.statusCode}');
      print('📥 Headers: ${response.headers}');
      print('📥 Body: ${response.body}');

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      } else {
        // Handle error response
        throw Exception(responseData['message'] ?? 'Failed to verify OTP');
      }
    } catch (e) {
      print('❌ API ERROR (verifyOtp): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Completes signup with user details
  /// Returns a map with 'success', 'message', and 'data' containing token and user
  static Future<Map<String, dynamic>> completeSignup({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String gender,
    required int age,
  }) async {
    try {
      final url = '$baseUrl/auth/complete-signup';
      final headers = {
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'gender': gender,
        'age': age,
      });

      print('📤 API REQUEST: POST $url');
      print('📤 Headers: $headers');
      print('📤 Body: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('📥 API RESPONSE: ${response.statusCode}');
      print('📥 Headers: ${response.headers}');
      print('📥 Body: ${response.body}');

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      } else {
        // Handle error response
        throw Exception(responseData['message'] ?? 'Failed to complete signup');
      }
    } catch (e) {
      print('❌ API ERROR (completeSignup): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Logs in with phone number and password
  /// Returns a map with 'success', 'message', and 'data' containing token and user
  static Future<Map<String, dynamic>> login(String phone, String password) async {
    try {
      final url = '$baseUrl/auth/login';
      final headers = {
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'phone': phone,
        'password': password,
      });

      print('📤 API REQUEST: POST $url');
      print('📤 Headers: $headers');
      print('📤 Body: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('📥 API RESPONSE: ${response.statusCode}');
      print('📥 Headers: ${response.headers}');
      print('📥 Body: ${response.body}');

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      } else {
        // Handle error response
        throw Exception(responseData['message'] ?? 'Failed to login');
      }
    } catch (e) {
      print('❌ API ERROR (login): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Sends OTP for password reset
  /// Returns a map with 'success', 'message', and 'data' containing userId and otp
  static Future<Map<String, dynamic>> forgotPasswordSendOtp(String phone) async {
    try {
      final url = '$baseUrl/auth/forgot-password/send-otp';
      final headers = {
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'phone': phone,
      });

      print('📤 API REQUEST: POST $url');
      print('📤 Headers: $headers');
      print('📤 Body: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('📥 API RESPONSE: ${response.statusCode}');
      print('📥 Headers: ${response.headers}');
      print('📥 Body: ${response.body}');

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      } else {
        // Handle error response
        throw Exception(responseData['message'] ?? 'Failed to send password reset OTP');
      }
    } catch (e) {
      print('❌ API ERROR (forgotPasswordSendOtp): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Verifies OTP for password reset
  /// Returns a map with 'success', 'message', and 'data' containing userId
  static Future<Map<String, dynamic>> forgotPasswordVerifyOtp(String phone, String otp) async {
    try {
      final url = '$baseUrl/auth/forgot-password/verify-otp';
      final headers = {
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'phone': phone,
        'otp': otp,
      });

      print('📤 API REQUEST: POST $url');
      print('📤 Headers: $headers');
      print('📤 Body: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('📥 API RESPONSE: ${response.statusCode}');
      print('📥 Headers: ${response.headers}');
      print('📥 Body: ${response.body}');

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      } else {
        // Handle error response
        throw Exception(responseData['message'] ?? 'Failed to verify OTP');
      }
    } catch (e) {
      print('❌ API ERROR (forgotPasswordVerifyOtp): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Resets password for forgot password flow
  /// Returns a map with 'success', 'message', and 'data' containing userId
  static Future<Map<String, dynamic>> forgotPasswordReset(String phone, String newPassword) async {
    try {
      final url = '$baseUrl/auth/forgot-password/reset';
      final headers = {
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'phone': phone,
        'newPassword': newPassword,
      });

      print('📤 API REQUEST: POST $url');
      print('📤 Headers: $headers');
      print('📤 Body: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('📥 API RESPONSE: ${response.statusCode}');
      print('📥 Headers: ${response.headers}');
      print('📥 Body: ${response.body}');

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      } else {
        // Handle error response
        throw Exception(responseData['message'] ?? 'Failed to reset password');
      }
    } catch (e) {
      print('❌ API ERROR (forgotPasswordReset): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }
}

