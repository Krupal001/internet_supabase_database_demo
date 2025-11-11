import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_db/features/userdata/domain/usecases/get_geolocation_usecase.dart';
import 'package:supabase_db/features/userdata/domain/usecases/search_by_geolocation_usecase.dart';
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
  final GetGeolocationUseCase getGeolocationUseCase;
  final SearchByGeolocationUseCase searchByGeolocationUseCase;

  UserDataCubit({
    required this.getAllUserDataUseCase,
    required this.createUserDataUseCase,
    required this.deleteUserDataUseCase,
    required this.getGeolocationUseCase,
    required this.searchByGeolocationUseCase,
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

  // for getting geolocation api
  Future<void> getGeolocation() async {
    emit(const UserDataLoading());
    final result = await getGeolocationUseCase();
    result.fold(
      onFailure: (failure) => emit(UserDataError(failure.message)),
      onSuccess: (geolocation) => emit(GeolocationLoaded(geolocation)),
    );
  }

  /// Search user data by geolocation (exact match + 200 miles radius fallback)
  Future<void> searchByGeolocation() async {
    emit(const UserDataLoading());
    
    // First get geolocation
    final geolocationResult = await getGeolocationUseCase();
    
    await geolocationResult.fold(
      onFailure: (failure) async {
        emit(UserDataError(failure.message));
      },
      onSuccess: (geolocation) async {
        // Emit geolocation loaded first
        emit(GeolocationLoaded(geolocation));
        
        // Then search for user data
        emit(const UserDataLoading());
        final searchResult = await searchByGeolocationUseCase(geolocation);
        
        searchResult.fold(
          onFailure: (failure) => emit(UserDataError(failure.message)),
          onSuccess: (results) {
            if (results.isEmpty) {
              emit(const UserDataError('No results found in your area'));
            } else {
              emit(SearchResultsLoaded(results, 'location'));
            }
          },
        );
      },
    );
  }
}
