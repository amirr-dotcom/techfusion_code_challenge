import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? image,
    String? gender,
    String? phone,
    String? birthDate,
    int? age,
    UserAddress? address,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          image: image,
          gender: gender,
          phone: phone,
          birthDate: birthDate,
          age: age,
          address: address,
        );

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      email: json['email']?.toString(),
      image: json['image']?.toString(),
      gender: json['gender']?.toString(),
      phone: json['phone']?.toString(),
      birthDate: json['birthDate']?.toString(),
      age: json['age'] is int ? json['age'] : int.tryParse(json['age']?.toString() ?? ''),
      address: json['address'] != null ? UserAddressModel.fromJson(json['address']) : null,
    );
  }
}

class UserAddressModel extends UserAddress {
  const UserAddressModel({
    String? address,
    String? city,
    String? state,
    String? country,
  }) : super(
          address: address,
          city: city,
          state: state,
          country: country,
        );

  factory UserAddressModel.fromJson(Map<dynamic, dynamic> json) {
    return UserAddressModel(
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      country: json['country']?.toString(),
    );
  }
}
