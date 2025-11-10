import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_data_entity.dart';
import '../../domain/repositories/user_data_repository.dart';
import '../datasources/user_data_remote_datasource.dart';
import '../models/user_data_model.dart';

/// Repository implementation for user data
class UserDataRepositoryImpl implements UserDataRepository {
  final UserDataRemoteDataSource remoteDataSource;

  UserDataRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<UserDataEntity>>> getAllUserData() async {
    try {
      final userDataList = await remoteDataSource.getAllUserData();
      return Result.success(userDataList);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserDataEntity>> getUserDataById(String firstName) async {
    try {
      final userData = await remoteDataSource.getUserDataById(firstName);
      return Result.success(userData);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserDataEntity>> createUserData(UserDataEntity userData) async {
    try {
      final model = UserDataModel.fromEntity(userData);
      final createdData = await remoteDataSource.createUserData(model);
      return Result.success(createdData);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserDataEntity>> updateUserData(UserDataEntity userData) async {
    try {
      final model = UserDataModel.fromEntity(userData);
      final updatedData = await remoteDataSource.updateUserData(model);
      return Result.success(updatedData);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteUserData(String firstName) async {
    try {
      await remoteDataSource.deleteUserData(firstName);
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
