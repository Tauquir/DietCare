import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';

class SubscriptionService {
  static String get baseUrl => ApiConfig.baseUrl;

  /// Fetches user's subscriptions
  /// Returns a map with 'success', 'message', and 'data' containing subscriptions array
  /// Requires authentication token
  static Future<Map<String, dynamic>> getMySubscriptions({String? token}) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/subscriptions/my-subscriptions';
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
        throw Exception(responseData['message'] ?? 'Failed to fetch subscriptions');
      }
    } catch (e) {
      print('❌ API ERROR (getMySubscriptions): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Fetches a subscription by ID
  /// Returns a map with 'success', 'message', and 'data' containing subscription details
  /// Requires authentication token
  static Future<Map<String, dynamic>> getSubscriptionById({
    required String subscriptionId,
    String? token,
  }) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/subscriptions/$subscriptionId';
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
        throw Exception(responseData['message'] ?? 'Failed to fetch subscription');
      }
    } catch (e) {
      print('❌ API ERROR (getSubscriptionById): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Updates a subscription
  /// Returns a map with 'success', 'message', and 'data' containing updated subscription details
  /// Requires authentication token
  static Future<Map<String, dynamic>> updateSubscription({
    required String subscriptionId,
    required String deliveryAddress,
    String? specialInstructions,
    String? token,
  }) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/subscriptions/$subscriptionId';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final body = jsonEncode({
        'deliveryAddress': deliveryAddress,
        if (specialInstructions != null && specialInstructions.isNotEmpty)
          'specialInstructions': specialInstructions,
      });

      print('📤 API REQUEST: PUT $url');
      print('📤 Headers: $headers');
      print('📤 Body: $body');

      final response = await http.put(
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
        throw Exception(responseData['message'] ?? 'Failed to update subscription');
      }
    } catch (e) {
      print('❌ API ERROR (updateSubscription): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Cancels a subscription
  /// Returns a map with 'success', 'message', and 'data' containing cancelled subscription details
  /// Requires authentication token
  static Future<Map<String, dynamic>> cancelSubscription({
    required String subscriptionId,
    required String reason,
    String? token,
  }) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/subscriptions/$subscriptionId/cancel';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final body = jsonEncode({
        'reason': reason,
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
        throw Exception(responseData['message'] ?? 'Failed to cancel subscription');
      }
    } catch (e) {
      print('❌ API ERROR (cancelSubscription): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Freezes a subscription
  /// Returns a map with 'success', 'message', and 'data' containing freeze details
  /// Requires authentication token
  static Future<Map<String, dynamic>> freezeSubscription({
    required String subscriptionId,
    required String startDate, // Format: "YYYY-MM-DD"
    required String endDate,   // Format: "YYYY-MM-DD"
    required String reason,
    String? token,
  }) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/subscriptions/$subscriptionId/freeze';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final body = jsonEncode({
        'startDate': startDate,
        'endDate': endDate,
        'reason': reason,
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
        throw Exception(responseData['message'] ?? 'Failed to freeze subscription');
      }
    } catch (e) {
      print('❌ API ERROR (freezeSubscription): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Resumes a subscription
  /// Returns a map with 'success', 'message', and 'data' containing payment details
  /// Requires authentication token
  static Future<Map<String, dynamic>> resumeSubscription({
    required String subscriptionId,
    String? token,
  }) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/subscriptions/$subscriptionId/resume';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      print('📤 API REQUEST: POST $url');
      print('📤 Headers: $headers');

      final response = await http.post(
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
        throw Exception(responseData['message'] ?? 'Failed to resume subscription');
      }
    } catch (e) {
      print('❌ API ERROR (resumeSubscription): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Gets freeze history for a subscription
  /// Returns a map with 'success', 'message', and 'data' containing freezes array
  /// Requires authentication token
  static Future<Map<String, dynamic>> getFreezeHistory({
    required String subscriptionId,
    String? token,
  }) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/subscriptions/$subscriptionId/freeze-history';
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
        throw Exception(responseData['message'] ?? 'Failed to fetch freeze history');
      }
    } catch (e) {
      print('❌ API ERROR (getFreezeHistory): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }
}

