import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';

class UserService {
  static String get baseUrl => ApiConfig.baseUrl;

  /// Fetches account details
  /// Query parameter: goal (e.g., 'lifestyle')
  /// Returns a map with 'success', 'message', and 'data' containing account details
  /// Requires authentication token
  static Future<Map<String, dynamic>> getAccountDetails({
    String? token,
    String goal = 'lifestyle',
  }) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/users/account-details?goal=$goal';
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
        throw Exception(responseData['message'] ?? 'Failed to fetch account details');
      }
    } catch (e) {
      print('❌ API ERROR (getAccountDetails): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Fetches user profile
  /// Returns a map with 'success', 'message', and 'data' containing profile
  /// Requires authentication token
  static Future<Map<String, dynamic>> getProfile({String? token}) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/users/profile';
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
        throw Exception(responseData['message'] ?? 'Failed to fetch profile');
      }
    } catch (e) {
      print('❌ API ERROR (getProfile): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Updates user profile
  /// Requires authentication token
  /// Request body: firstName, lastName, height, weight, targetWeight, activityLevel, 
  /// dietaryPreferences, allergies, medicalConditions, gender, age
  static Future<Map<String, dynamic>> updateProfile({
    required String token,
    required String firstName,
    required String lastName,
    int? height,
    int? weight,
    int? targetWeight,
    String? activityLevel,
    String? dietaryPreferences,
    String? allergies,
    String? medicalConditions,
    String? gender,
    int? age,
  }) async {
    try {
      final url = '$baseUrl/users/profile';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      
      final bodyMap = <String, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
      };
      
      // Include optional fields - match API request body format
      if (height != null) bodyMap['height'] = height;
      if (weight != null) bodyMap['weight'] = weight;
      if (targetWeight != null) bodyMap['targetWeight'] = targetWeight;
      if (activityLevel != null && activityLevel.isNotEmpty) bodyMap['activityLevel'] = activityLevel;
      if (dietaryPreferences != null && dietaryPreferences.isNotEmpty) bodyMap['dietaryPreferences'] = dietaryPreferences;
      if (allergies != null && allergies.isNotEmpty) bodyMap['allergies'] = allergies;
      // medicalConditions can be null - include it if provided
      if (medicalConditions != null) {
        bodyMap['medicalConditions'] = medicalConditions.isEmpty ? null : medicalConditions;
      }
      if (gender != null && gender.isNotEmpty) bodyMap['gender'] = gender;
      if (age != null) bodyMap['age'] = age;
      
      final body = jsonEncode(bodyMap);

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
        throw Exception(responseData['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      print('❌ API ERROR (updateProfile): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Adds a new address for the user
  /// Requires authentication token
  static Future<Map<String, dynamic>> addAddress({
    required String token,
    required String type,
    required String street,
    required String city,
    required String state,
    required String zipCode,
    required String country,
    required bool isDefault,
    double? latitude,
    double? longitude,
    String? addressName,
    String? fullName,
    String? phone,
    String? building,
    String? floor,
    String? flat,
  }) async {
    try {
      final url = '$baseUrl/users/addresses';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final bodyMap = <String, dynamic>{
        'type': type,
        'street': street,
        'city': city,
        'state': state,
        'zipCode': zipCode,
        'country': country,
        'isDefault': isDefault,
      };
      
      // Add optional fields if provided
      if (latitude != null) bodyMap['latitude'] = latitude;
      if (longitude != null) bodyMap['longitude'] = longitude;
      if (addressName != null) bodyMap['addressName'] = addressName;
      if (fullName != null) bodyMap['fullName'] = fullName;
      if (phone != null) bodyMap['phone'] = phone;
      if (building != null) bodyMap['building'] = building;
      if (floor != null) bodyMap['floor'] = floor;
      if (flat != null) bodyMap['flat'] = flat;
      
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
        throw Exception(responseData['message'] ?? 'Failed to add address');
      }
    } catch (e) {
      print('❌ API ERROR (addAddress): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Fetches all addresses for the user
  /// Requires authentication token
  static Future<Map<String, dynamic>> getAddresses({String? token}) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/users/addresses';
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
        throw Exception(responseData['message'] ?? 'Failed to fetch addresses');
      }
    } catch (e) {
      print('❌ API ERROR (getAddresses): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Fetches user's favorite meal plans
  /// Returns a map with 'success', 'message', and 'data' containing favorites array
  /// Requires authentication token
  static Future<Map<String, dynamic>> getFavoriteMealPlans({String? token}) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/users/favorite-meal-plans';
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
        throw Exception(responseData['message'] ?? 'Failed to fetch favorite meal plans');
      }
    } catch (e) {
      print('❌ API ERROR (getFavoriteMealPlans): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Adds a meal plan to favorites
  /// Request body: mealPlanId, name, image
  /// Returns a map with 'success', 'message', and 'data' containing favorite object
  /// Requires authentication token
  static Future<Map<String, dynamic>> addFavoriteMealPlan({
    required String token,
    required int mealPlanId,
    required String name,
    String? image,
  }) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/users/favorite-meal-plans';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      
      final bodyMap = <String, dynamic>{
        'mealPlanId': mealPlanId,
        'name': name,
      };
      
      if (image != null && image.isNotEmpty) {
        bodyMap['image'] = image;
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
        throw Exception(responseData['message'] ?? 'Failed to add favorite meal plan');
      }
    } catch (e) {
      print('❌ API ERROR (addFavoriteMealPlan): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Removes a meal plan from favorites
  /// DELETE /api/users/favorite-meal-plans/:mealPlanId
  /// Returns a map with 'success', 'message'
  /// Requires authentication token
  static Future<Map<String, dynamic>> removeFavoriteMealPlan({
    required String token,
    required int mealPlanId,
  }) async {
    try {
      // Token is required for this endpoint
      if (token == null || token.isEmpty) {
        throw Exception('No token provided');
      }

      final url = '$baseUrl/users/favorite-meal-plans/$mealPlanId';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      print('📤 API REQUEST: DELETE $url');
      print('📤 Headers: $headers');

      final response = await http.delete(
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
        throw Exception(responseData['message'] ?? 'Failed to remove favorite meal plan');
      }
    } catch (e) {
      print('❌ API ERROR (removeFavoriteMealPlan): ${e.toString()}');
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }
}

