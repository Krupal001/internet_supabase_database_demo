import '../../../../core/utils/result.dart';
import '../repositories/user_data_repository.dart';

/// Use case for deleting user data
class DeleteUserDataUseCase {
  final UserDataRepository repository;

  DeleteUserDataUseCase(this.repository);

  Future<Result<void>> call(String firstName) async {
    return await repository.deleteUserData(firstName);
  }
}
