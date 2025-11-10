import '../../../../core/utils/result.dart';
import '../entities/user_data_entity.dart';
import '../repositories/user_data_repository.dart';

/// Use case for creating user data
class CreateUserDataUseCase {
  final UserDataRepository repository;

  CreateUserDataUseCase(this.repository);

  Future<Result<UserDataEntity>> call(UserDataEntity userData) async {
    return await repository.createUserData(userData);
  }
}
