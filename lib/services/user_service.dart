import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';

class UserService {
  static String get baseUrl => ApiConfig.baseUrl;

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
  static Future<Map<String, dynamic>> updateProfile({
    required String token,
    required int height,
    required int weight,
    required int targetWeight,
    required String activityLevel,
  }) async {
    try {
      final url = '$baseUrl/users/profile';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final body = jsonEncode({
        'height': height,
        'weight': weight,
        'targetWeight': targetWeight,
        'activityLevel': activityLevel,
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
}

