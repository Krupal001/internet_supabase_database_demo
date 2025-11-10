import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/supabase_config.dart';
import '../models/user_data_model.dart';

/// Abstract remote data source for user data
abstract class UserDataRemoteDataSource {
  Future<List<UserDataModel>> getAllUserData();
  Future<UserDataModel> getUserDataById(String firstName);
  Future<UserDataModel> createUserData(UserDataModel userData);
  Future<UserDataModel> updateUserData(UserDataModel userData);
  Future<void> deleteUserData(String firstName);
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
}
