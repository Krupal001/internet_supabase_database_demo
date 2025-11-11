import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../features/userdata/data/datasources/user_data_remote_datasource.dart';
import '../../features/userdata/data/repositories/user_data_repository_impl.dart';
import '../../features/userdata/domain/repositories/user_data_repository.dart';
import '../../features/userdata/domain/usecases/create_userdata_usecase.dart';
import '../../features/userdata/domain/usecases/delete_userdata_usecase.dart';
import '../../features/userdata/domain/usecases/get_all_userdata_usecase.dart';
import '../../features/userdata/domain/usecases/get_geolocation_usecase.dart';
import '../../features/userdata/domain/usecases/search_by_geolocation_usecase.dart';
import '../../features/userdata/presentation/cubit/user_data_cubit.dart';

/// Service locator for dependency injection
final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // ========== External: HTTP Client ==========
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // ========== Features: UserData ==========

  // Cubit
  sl.registerFactory(
    () => UserDataCubit(
      getAllUserDataUseCase: sl(),
      createUserDataUseCase: sl(),
      deleteUserDataUseCase: sl(),
      getGeolocationUseCase: sl(),
      searchByGeolocationUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllUserDataUseCase(sl()));
  sl.registerLazySingleton(() => CreateUserDataUseCase(sl()));
  sl.registerLazySingleton(() => DeleteUserDataUseCase(sl()));
  sl.registerLazySingleton(() => GetGeolocationUseCase(sl()));
  sl.registerLazySingleton(() => SearchByGeolocationUseCase(sl()));

  // Repository
  sl.registerLazySingleton<UserDataRepository>(
    () => UserDataRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<UserDataRemoteDataSource>(
    () => UserDataRemoteDataSourceImpl(httpClient: sl()),
  );
}
