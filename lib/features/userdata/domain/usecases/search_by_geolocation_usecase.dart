import 'package:supabase_db/core/error/failures.dart';
import 'package:supabase_db/core/utils/result.dart';
import 'package:supabase_db/features/userdata/domain/entities/geolocation_entity.dart';
import 'package:supabase_db/features/userdata/domain/entities/user_data_entity.dart';
import 'package:supabase_db/features/userdata/domain/repositories/user_data_repository.dart';

/// Use case for searching user data based on geolocation
/// First tries exact match, then searches within 200 miles radius
class SearchByGeolocationUseCase {
  final UserDataRepository repository;

  SearchByGeolocationUseCase(this.repository);

  Future<Result<List<UserDataEntity>>> call(
    GeolocationEntity geolocation,
  ) async {
    try {
      // Parse zip code from geolocation (it's a string, need to convert)
      final zipCode = int.tryParse(geolocation.zip);

      if (zipCode == null) {
        return Result.failure(
          ServerFailure('Invalid zip code: ${geolocation.zip}'),
        );
      }

      // Call the repository method which handles both exact match and state fallback
      final searchResult = await repository.searchByGeolocation(
        city: geolocation.city,
        state: geolocation.regionName,
        zip: zipCode,
      );

      return searchResult.fold(
        onFailure: (failure) {
          print('❌ Search failed: ${failure.message}');
          return Result.failure(failure);
        },
        onSuccess: (results) {
          if (results.isNotEmpty) {
            print('✅ Search completed: Found ${results.length} results');
          } else {
            print('⚠️ No results found');
          }
          return Result.success(results);
        },
      );
    } catch (e) {
      return Result.failure(ServerFailure('Search failed: $e'));
    }
  }
}
