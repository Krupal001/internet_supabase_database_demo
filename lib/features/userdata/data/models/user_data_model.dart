import '../../domain/entities/user_data_entity.dart';

/// UserData model - Data layer representation with JSON serialization
class UserDataModel extends UserDataEntity {
  const UserDataModel({
    required super.firstName,
    required super.lastName,
    required super.dob,
    required super.city,
    required super.state,
    required super.zip,
  });

  /// Create model from JSON (from API)
  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      dob: json['dob'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zip: json['zip'] as int,
    );
  }

  /// Convert model to JSON (for API)
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'dob': dob,
      'city': city,
      'state': state,
      'zip': zip,
    };
  }

  /// Create model from entity
  factory UserDataModel.fromEntity(UserDataEntity entity) {
    return UserDataModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
      dob: entity.dob,
      city: entity.city,
      state: entity.state,
      zip: entity.zip,
    );
  }
}
