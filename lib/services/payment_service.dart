import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';

class PaymentService {
  static String get baseUrl => ApiConfig.baseUrl;

  /// Fetches user's payments
  /// Returns a map with 'success', 'message', and 'data' containing payments array
  /// Requires authentication token
  static Future<Map<String, dynamic>> getMyPayments({String? token}) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/payments/my-payments';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      print('📤 API REQUEST: GET $url');
      print('📤 Headers: $headers');

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('📥 API RESPONSE: ${response.statusCode}');
      print('📥 Headers: ${response.headers}');
      print('📥 Body: ${response.body}');

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      } else {
        // Handle error response
        throw Exception(responseData['message'] ?? 'Failed to fetch payments');
      }
    } catch (e) {
      print('❌ API ERROR (getMyPayments): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Fetches a payment by ID
  /// Returns a map with 'success', 'message', and 'data' containing payment details
  /// Requires authentication token
  static Future<Map<String, dynamic>> getPaymentById({
    required String paymentId,
    String? token,
  }) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/payments/$paymentId';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      print('📤 API REQUEST: GET $url');
      print('📤 Headers: $headers');

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('📥 API RESPONSE: ${response.statusCode}');
      print('📥 Headers: ${response.headers}');
      print('📥 Body: ${response.body}');

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      } else {
        // Handle error response
        throw Exception(responseData['message'] ?? 'Failed to fetch payment');
      }
    } catch (e) {
      print('❌ API ERROR (getPaymentById): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Fetches payments by subscription ID
  /// Returns a map with 'success', 'message', and 'data' containing payments array
  /// Requires authentication token
  static Future<Map<String, dynamic>> getPaymentsBySubscription({
    required String subscriptionId,
    String? token,
  }) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/payments/subscription/$subscriptionId';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      print('📤 API REQUEST: GET $url');
      print('📤 Headers: $headers');

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('📥 API RESPONSE: ${response.statusCode}');
      print('📥 Headers: ${response.headers}');
      print('📥 Body: ${response.body}');

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      } else {
        // Handle error response
        throw Exception(responseData['message'] ?? 'Failed to fetch payments for subscription');
      }
    } catch (e) {
      print('❌ API ERROR (getPaymentsBySubscription): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Processes a payment
  /// Returns a map with 'success', 'message', and 'data' containing payment details
  /// Requires authentication token
  static Future<Map<String, dynamic>> processPayment({
    required String paymentId,
    required String paymentMethodId,
    required double amount,
    String? token,
  }) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/payments/$paymentId/process';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final body = jsonEncode({
        'paymentMethodId': paymentMethodId,
        'amount': amount,
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
        throw Exception(responseData['message'] ?? 'Failed to process payment');
      }
    } catch (e) {
      print('❌ API ERROR (processPayment): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Refunds a payment
  /// Returns a map with 'success', 'message', and 'data' containing refunded payment details
  /// Requires authentication token
  static Future<Map<String, dynamic>> refundPayment({
    required String paymentId,
    required String reason,
    required double amount,
    String? token,
  }) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/payments/$paymentId/refund';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final body = jsonEncode({
        'reason': reason,
        'amount': amount,
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
        throw Exception(responseData['message'] ?? 'Failed to refund payment');
      }
    } catch (e) {
      print('❌ API ERROR (refundPayment): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Gets transactions for a payment
  /// Returns a map with 'success', 'message', and 'data' containing transactions array
  /// Requires authentication token
  static Future<Map<String, dynamic>> getPaymentTransactions({
    required String paymentId,
    String? token,
  }) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/payments/$paymentId/transactions';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      print('📤 API REQUEST: GET $url');
      print('📤 Headers: $headers');

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('📥 API RESPONSE: ${response.statusCode}');
      print('📥 Headers: ${response.headers}');
      print('📥 Body: ${response.body}');

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      } else {
        // Handle error response
        throw Exception(responseData['message'] ?? 'Failed to fetch payment transactions');
      }
    } catch (e) {
      print('❌ API ERROR (getPaymentTransactions): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }
}

