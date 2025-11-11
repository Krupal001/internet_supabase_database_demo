import 'package:supabase_db/core/utils/result.dart';
import 'package:supabase_db/features/userdata/domain/entities/geolocation_entity.dart';
import 'package:supabase_db/features/userdata/domain/repositories/user_data_repository.dart';

class GetGeolocationUseCase {
  final UserDataRepository repository;

  GetGeolocationUseCase(this.repository);

  Future<Result<GeolocationEntity>> call() async {
    return await repository.getGeolocation();
  }
}
