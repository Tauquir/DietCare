import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';

class MealService {
  static String get baseUrl => ApiConfig.baseUrl;

  /// Fetches home page data
  /// Query parameters: lang, categoryId, page, perPage
  /// Returns a map with 'success', 'message', and 'data' containing:
  /// - greeting: String
  /// - banner: String (URL)
  /// - categories: List of category objects
  /// - selectedCategoryId: int
  /// - mealPlans: Object with data array and pagination
  static Future<Map<String, dynamic>> getHomeData({
    required String lang,
    int? categoryId,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/meals/home').replace(
        queryParameters: {
          'lang': lang,
          if (categoryId != null) 'categoryId': categoryId.toString(),
          'page': page.toString(),
          'perPage': perPage.toString(),
        },
      );

      final headers = {
        'Content-Type': 'application/json',
      };

      print('📤 API REQUEST: GET ${uri.toString()}');
      print('📤 Headers: $headers');

      final response = await http.get(
        uri,
        headers: headers,
      );

      print('📥 API RESPONSE: ${response.statusCode}');
      print('📥 Body: ${response.body}');

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      } else {
        // Handle error response
        throw Exception(responseData['message'] ?? 'Failed to fetch home data');
      }
    } catch (e) {
      print('❌ API ERROR (getHomeData): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Fetches meal details for a specific meal plan, day, and category
  /// Query parameters: lang, mealPlanId, DayId, mealCategoryId, userId, page, perPage
  /// Returns a map with 'success', 'message', and 'data' containing:
  /// - mealPlanId: int
  /// - day: String
  /// - categories: List of category objects with items
  static Future<Map<String, dynamic>> getMealDetails({
    required String lang,
    required int mealPlanId,
    required String dayId, // e.g., "MON", "TUE"
    required int mealCategoryId,
    String? userId,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/meals/detailQuery').replace(
        queryParameters: {
          'lang': lang,
          'mealPlanId': mealPlanId.toString(),
          'DayId': dayId,
          'mealCategoryId': mealCategoryId.toString(),
          if (userId != null && userId.isNotEmpty) 'userId': userId,
          'page': page.toString(),
          'perPage': perPage.toString(),
        },
      );

      final headers = {
        'Content-Type': 'application/json',
      };

      print('📤 API REQUEST: GET ${uri.toString()}');
      print('📤 Headers: $headers');

      final response = await http.get(
        uri,
        headers: headers,
      );

      print('📥 API RESPONSE: ${response.statusCode}');
      print('📥 Body: ${response.body}');

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      } else {
        // Handle error response
        throw Exception(responseData['message'] ?? 'Failed to fetch meal details');
      }
    } catch (e) {
      print('❌ API ERROR (getMealDetails): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Fetches meal details from /meals/details endpoint
  /// Query parameters: lang, mealPlanId, DayId, mealCategoryId, userId, page, perPage
  /// Returns a map with 'success', 'message', and 'data' containing:
  /// - mealPlanId: int
  /// - day: String
  /// - categories: List of category objects with items
  static Future<Map<String, dynamic>> getMealDetailsFromDetails({
    required String lang,
    required int mealPlanId,
    required String dayId, // e.g., "MON", "TUE"
    required int mealCategoryId,
    String? userId,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/meals/details').replace(
        queryParameters: {
          'lang': lang,
          'mealPlanId': mealPlanId.toString(),
          'DayId': dayId,
          'mealCategoryId': mealCategoryId.toString(),
          if (userId != null && userId.isNotEmpty) 'userId': userId,
          'page': page.toString(),
          'perPage': perPage.toString(),
        },
      );

      final headers = {
        'Content-Type': 'application/json',
      };

      print('📤 API REQUEST: GET ${uri.toString()}');
      print('📤 Headers: $headers');

      final response = await http.get(
        uri,
        headers: headers,
      );

      print('📥 API RESPONSE: ${response.statusCode}');
      print('📥 Body: ${response.body}');

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      } else {
        // Handle error response
        throw Exception(responseData['message'] ?? 'Failed to fetch meal details');
      }
    } catch (e) {
      print('❌ API ERROR (getMealDetailsFromDetails): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }
}

