import '../../../../core/utils/result.dart';
import '../entities/user_data_entity.dart';
import '../repositories/user_data_repository.dart';

/// Use case for getting all user data
class GetAllUserDataUseCase {
  final UserDataRepository repository;

  GetAllUserDataUseCase(this.repository);

  Future<Result<List<UserDataEntity>>> call() async {
    return await repository.getAllUserData();
  }
}
