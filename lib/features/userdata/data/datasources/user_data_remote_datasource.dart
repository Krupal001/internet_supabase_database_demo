import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_db/features/userdata/data/models/geolocation_model.dart';
import '../../../../core/config/supabase_config.dart';
import '../models/user_data_model.dart';

/// Abstract remote data source for user data
abstract class UserDataRemoteDataSource {
  Future<List<UserDataModel>> getAllUserData();
  Future<UserDataModel> getUserDataById(String firstName);
  Future<UserDataModel> createUserData(UserDataModel userData);
  Future<UserDataModel> updateUserData(UserDataModel userData);
  Future<void> deleteUserData(String firstName);
  Future<GeolocationModel> getGeolocation();
  Future<List<UserDataModel>> searchByGeolocation({
    required String city,
    required String state,
    required int zip,
  });
}

/// Implementation using HTTP API calls
class UserDataRemoteDataSourceImpl implements UserDataRemoteDataSource {
  final http.Client httpClient;

  UserDataRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<List<UserDataModel>> getAllUserData() async {
    try {
      final url = Uri.parse('${ApiConfig.userDataUrl}?select=*');
      final response = await httpClient.get(url, headers: ApiConfig.headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => UserDataModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }

  @override
  Future<UserDataModel> getUserDataById(String firstName) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.userDataUrl}?first_name=eq.$firstName&select=*',
      );
      final response = await httpClient.get(url, headers: ApiConfig.headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        if (jsonList.isEmpty) {
          throw Exception('User data not found');
        }
        return UserDataModel.fromJson(jsonList.first as Map<String, dynamic>);
      } else {
        throw Exception(
          'Failed to fetch user data by ID: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch user data by ID: $e');
    }
  }

  @override
  Future<UserDataModel> createUserData(UserDataModel userData) async {
    try {
      final url = Uri.parse('${ApiConfig.userDataUrl}?select=*');
      final response = await httpClient.post(
        url,
        headers: ApiConfig.headers,
        body: json.encode(userData.toJson()),
      );

      if (response.statusCode == 201) {
        final List<dynamic> jsonList = json.decode(response.body);
        return UserDataModel.fromJson(jsonList.first as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create user data: $e');
    }
  }

  @override
  Future<UserDataModel> updateUserData(UserDataModel userData) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.userDataUrl}?first_name=eq.${userData.firstName}&select=*',
      );
      final response = await httpClient.patch(
        url,
        headers: ApiConfig.headers,
        body: json.encode(userData.toJson()),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return UserDataModel.fromJson(jsonList.first as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update user data: $e');
    }
  }

  @override
  Future<void> deleteUserData(String firstName) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.userDataUrl}?first_name=eq.$firstName',
      );
      final response = await httpClient.delete(url, headers: ApiConfig.headers);

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete user data: $e');
    }
  }

  @override
  Future<GeolocationModel> getGeolocation() async {
    try {
      final url = Uri.parse('${ApiConfig.geolocationUrl}94.26.84.72');
      print('🌍 Fetching geolocation from: $url');

      final response = await httpClient.get(url);

      print('📡 Response Status Code: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print('✅ Geolocation Data: $jsonData');

        final geolocationModel = GeolocationModel.fromJson(jsonData);
        print('🎯 Parsed Geolocation Model: ${geolocationModel.toJson()}');

        return geolocationModel;
      } else {
        throw Exception(
          'Failed to fetch geolocation data: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ Error fetching geolocation: $e');
      throw Exception('Failed to fetch geolocation data: $e');
    }
  }

  @override
  Future<List<UserDataModel>> searchByGeolocation({
    required String city,
    required String state,
    required int zip,
  }) async {
    try {
      // Step 1: Try exact location match (city, state, zip)
      final exactQueryParams = {
        'city': 'eq.$city',
        'state': 'eq.$state',
        'zip': 'eq.$zip',
        'select': '*',
      };

      final exactUri = Uri.parse(
        ApiConfig.userDataUrl,
      ).replace(queryParameters: exactQueryParams);

      print(
        '🔍 Step 1: Searching by exact location: city=$city, state=$state, zip=$zip',
      );
      print('📍 Query URL: $exactUri');

      final exactResponse = await httpClient.get(
        exactUri,
        headers: ApiConfig.headers,
      );

      if (exactResponse.statusCode == 200) {
        final List<dynamic> exactJsonList = json.decode(exactResponse.body);

        if (exactJsonList.isNotEmpty) {
          print(
            '✅ Found ${exactJsonList.length} results with exact location match',
          );
          return exactJsonList
              .map(
                (json) => UserDataModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        }

        // Step 2: No exact match found, search by state only
        print('⚠️ No exact match found, searching by state only: $state');

        final stateQueryParams = {'state': 'eq.$state', 'select': '*'};

        final stateUri = Uri.parse(
          ApiConfig.userDataUrl,
        ).replace(queryParameters: stateQueryParams);

        print('📍 Fallback Query URL: $stateUri');

        final stateResponse = await httpClient.get(
          stateUri,
          headers: ApiConfig.headers,
        );

        if (stateResponse.statusCode == 200) {
          final List<dynamic> stateJsonList = json.decode(stateResponse.body);
          print('✅ Found ${stateJsonList.length} results in state: $state');

          return stateJsonList
              .map(
                (json) => UserDataModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        } else {
          throw Exception(
            'Failed to search by state: ${stateResponse.statusCode}',
          );
        }
      } else {
        throw Exception(
          'Failed to search by location: ${exactResponse.statusCode}',
        );
      }
    } catch (e) {
      print('❌ Error searching by geolocation: $e');
      throw Exception('Failed to search by geolocation: $e');
    }
  }
}
