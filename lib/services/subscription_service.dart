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

  /// Creates a new subscription
  /// Request body: mealPlanId, durationDays, startDate, activePlanStartDate, totalAmount, addressId, specialInstructions
  /// Returns a map with 'success', 'message', and 'data' containing subscription details
  /// Requires authentication token
  static Future<Map<String, dynamic>> createSubscription({
    required int mealPlanId,
    required int durationDays,
    required String startDate, // Format: "YYYY-MM-DD"
    required String activePlanStartDate, // Format: "YYYY-MM-DD"
    required double totalAmount,
    required String addressId,
    String? specialInstructions,
    String? token,
  }) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/subscriptions';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      
      final bodyMap = <String, dynamic>{
        'mealPlanId': mealPlanId,
        'durationDays': durationDays,
        'startDate': startDate,
        'activePlanStartDate': activePlanStartDate,
        'totalAmount': totalAmount,
        'addressId': addressId,
      };
      
      if (specialInstructions != null && specialInstructions.isNotEmpty) {
        bodyMap['specialInstructions'] = specialInstructions;
      }
      
      final body = jsonEncode(bodyMap);

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        // Handle error response
        throw Exception(responseData['message'] ?? 'Failed to create subscription');
      }
    } catch (e) {
      print('❌ API ERROR (createSubscription): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Fetches daily selection status for a subscription
  /// Path parameters: subscriptionId, mealPlanId
  /// Query parameters: startDate, endDate (format: yyyy-mm-dd)
  /// Returns a map with 'success', 'message', and 'data' containing:
  /// - mealPlan: Object with id and code
  /// - status: Array of daily status objects
  static Future<Map<String, dynamic>> getDailySelectionStatus({
    required String subscriptionId,
    required int mealPlanId,
    required String startDate, // Format: "YYYY-MM-DD"
    required String endDate, // Format: "YYYY-MM-DD"
    String? token,
  }) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/meals/subscriptions/$subscriptionId/meal-plans/$mealPlanId/daily-selections/status';
      final uri = Uri.parse(url).replace(
        queryParameters: {
          'startDate': startDate,
          'endDate': endDate,
        },
      );

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      print('📤 API REQUEST: GET ${uri.toString()}');
      print('📤 Headers: $headers');

      final response = await http.get(
        uri,
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
        throw Exception(responseData['message'] ?? 'Failed to fetch daily selection status');
      }
    } catch (e) {
      print('❌ API ERROR (getDailySelectionStatus): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Fetches daily meal selections for a specific date
  /// Path parameters: subscriptionId, mealPlanId, date (format: yyyy-mm-dd)
  /// Returns a map with 'success', 'message', and 'data' containing:
  /// - date: String
  /// - dayOfWeek: String
  /// - mealPlan: Object with id, code, name
  /// - totalSelected: int
  /// - categories: Array of category objects with items and selected quantities
  static Future<Map<String, dynamic>> getDailySelections({
    required String subscriptionId,
    required int mealPlanId,
    required String date, // Format: "YYYY-MM-DD"
    String? token,
  }) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/meals/subscriptions/$subscriptionId/meal-plans/$mealPlanId/daily-selections/$date';

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
        throw Exception(responseData['message'] ?? 'Failed to fetch daily selections');
      }
    } catch (e) {
      print('❌ API ERROR (getDailySelections): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Saves daily meal selections for a specific date
  /// Path parameters: subscriptionId, mealPlanId, date (format: yyyy-mm-dd)
  /// Body: { "selections": [ { "itemId": int, "mealCategoryId": int, "quantity": int } ] }
  /// Returns a map with 'success', 'message', and 'data' containing the saved selections
  static Future<Map<String, dynamic>> saveDailySelections({
    required String subscriptionId,
    required int mealPlanId,
    required String date, // Format: "YYYY-MM-DD"
    required List<Map<String, dynamic>> selections, // [{itemId, mealCategoryId, quantity}]
    String? token,
  }) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/meals/subscriptions/$subscriptionId/meal-plans/$mealPlanId/daily-selections/$date';

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = jsonEncode({
        'selections': selections,
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        // Handle error response
        throw Exception(responseData['message'] ?? 'Failed to save daily selections');
      }
    } catch (e) {
      print('❌ API ERROR (saveDailySelections): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }
}

