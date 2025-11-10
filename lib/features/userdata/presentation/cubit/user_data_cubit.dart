import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_data_entity.dart';
import '../../domain/usecases/create_userdata_usecase.dart';
import '../../domain/usecases/delete_userdata_usecase.dart';
import '../../domain/usecases/get_all_userdata_usecase.dart';
import 'user_data_state.dart';

/// UserData Cubit - Manages user data state
class UserDataCubit extends Cubit<UserDataState> {
  final GetAllUserDataUseCase getAllUserDataUseCase;
  final CreateUserDataUseCase createUserDataUseCase;
  final DeleteUserDataUseCase deleteUserDataUseCase;

  UserDataCubit({
    required this.getAllUserDataUseCase,
    required this.createUserDataUseCase,
    required this.deleteUserDataUseCase,
  }) : super(const UserDataInitial());

  /// Load all user data from API
  Future<void> loadAllUserData() async {
    emit(const UserDataLoading());

    final result = await getAllUserDataUseCase();

    result.fold(
      onFailure: (failure) => emit(UserDataError(failure.message)),
      onSuccess: (userDataList) => emit(UserDataListLoaded(userDataList)),
    );
  }

  /// Create new user data
  Future<void> createUserData(UserDataEntity userData) async {
    emit(const UserDataLoading());

    final result = await createUserDataUseCase(userData);

    result.fold(
      onFailure: (failure) => emit(UserDataError(failure.message)),
      onSuccess: (createdData) {
        emit(const UserDataSuccess('User data created successfully'));
        // Reload the list
        loadAllUserData();
      },
    );
  }

  /// Delete user data by first name
  Future<void> deleteUserData(String firstName) async {
    emit(const UserDataLoading());

    final result = await deleteUserDataUseCase(firstName);

    result.fold(
      onFailure: (failure) => emit(UserDataError(failure.message)),
      onSuccess: (_) {
        emit(const UserDataSuccess('User data deleted successfully'));
        // Reload the list
        loadAllUserData();
      },
    );
  }
}
