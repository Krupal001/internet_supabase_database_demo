import 'package:equatable/equatable.dart';

/// UserData entity - Pure business object
class UserDataEntity extends Equatable {
  final String firstName;
  final String lastName;
  final String dob;
  final String city;
  final String state;
  final int zip;

  const UserDataEntity({
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.city,
    required this.state,
    required this.zip,
  });

  @override
  List<Object?> get props => [firstName, lastName, dob, city, state, zip];
}
