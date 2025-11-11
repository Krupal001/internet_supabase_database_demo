import 'package:equatable/equatable.dart';
import 'package:supabase_db/features/userdata/domain/entities/geolocation_entity.dart';
import '../../domain/entities/user_data_entity.dart';

/// Base state for user data
abstract class UserDataState extends Equatable {
  const UserDataState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class UserDataInitial extends UserDataState {
  const UserDataInitial();
}

/// Loading state
class UserDataLoading extends UserDataState {
  const UserDataLoading();
}

/// Loaded state with list of user data
class UserDataListLoaded extends UserDataState {
  final List<UserDataEntity> userDataList;

  const UserDataListLoaded(this.userDataList);

  @override
  List<Object> get props => [userDataList];
}

/// Single user data loaded
class UserDataLoaded extends UserDataState {
  final UserDataEntity userData;

  const UserDataLoaded(this.userData);

  @override
  List<Object> get props => [userData];
}

/// Geolocation loaded
class GeolocationLoaded extends UserDataState {
  final GeolocationEntity geolocation;

  const GeolocationLoaded(this.geolocation);

  @override
  List<Object> get props => [geolocation];
}

/// Search results loaded
class SearchResultsLoaded extends UserDataState {
  final List<UserDataEntity> results;
  final String searchType; // 'exact' or 'radius'

  const SearchResultsLoaded(this.results, this.searchType);

  @override
  List<Object> get props => [results, searchType];
}

/// Success state (for create/update/delete operations)
class UserDataSuccess extends UserDataState {
  final String message;

  const UserDataSuccess(this.message);

  @override
  List<Object> get props => [message];
}

/// Error state
class UserDataError extends UserDataState {
  final String message;

  const UserDataError(this.message);

  @override
  List<Object> get props => [message];
}
