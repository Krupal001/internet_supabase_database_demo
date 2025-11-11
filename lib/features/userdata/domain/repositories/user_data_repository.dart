import 'package:supabase_db/features/userdata/domain/entities/geolocation_entity.dart';

import '../../../../core/utils/result.dart';
import '../entities/user_data_entity.dart';

/// Abstract repository for user data operations
abstract class UserDataRepository {
  /// Get all user data from API
  Future<Result<List<UserDataEntity>>> getAllUserData();

  /// Get single user data by first name
  Future<Result<UserDataEntity>> getUserDataById(String firstName);

  /// Create new user data
  Future<Result<UserDataEntity>> createUserData(UserDataEntity userData);

  /// Update existing user data
  Future<Result<UserDataEntity>> updateUserData(UserDataEntity userData);

  /// Delete user data by first name
  Future<Result<void>> deleteUserData(String firstName);

  /// Get geolocation data
  Future<Result<GeolocationEntity>> getGeolocation();

  /// Search user data by location with fallback
  /// First tries exact match (city, state, zip), then falls back to state-only
  Future<Result<List<UserDataEntity>>> searchByGeolocation({
    required String city,
    required String state,
    required int zip,
  });
}
