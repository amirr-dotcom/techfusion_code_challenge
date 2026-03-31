import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? image;
  final String? gender;
  final String? phone;
  final String? birthDate;
  final int? age;
  final UserAddress? address;

  const User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.image,
    this.gender,
    this.phone,
    this.birthDate,
    this.age,
    this.address,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        image,
        gender,
        phone,
        birthDate,
        age,
        address,
      ];
}

class UserAddress extends Equatable {
  final String? address;
  final String? city;
  final String? state;
  final String? country;

  const UserAddress({
    this.address,
    this.city,
    this.state,
    this.country,
  });

  @override
  List<Object?> get props => [address, city, state, country];
}
