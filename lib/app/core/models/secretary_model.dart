import 'package:agendarep/app/core/models/user_profile_model.dart';

class SecretaryModel {
  final String? id;
  final UserProfileModel? seller;
  final String? email;
  final String? name;
  final String? phone;
  final DateTime? birthday;
  SecretaryModel({
    this.id,
    this.seller,
    this.email,
    this.name,
    this.phone,
    this.birthday,
  });

  SecretaryModel copyWith({
    String? id,
    UserProfileModel? seller,
    String? email,
    String? name,
    String? phone,
    DateTime? birthday,
  }) {
    return SecretaryModel(
      id: id ?? this.id,
      seller: seller ?? this.seller,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
    );
  }

  @override
  String toString() {
    return 'SecretaryModel(id: $id, seller: $seller, email: $email, name: $name, phone: $phone, birthday: $birthday)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SecretaryModel &&
        other.id == id &&
        other.seller == seller &&
        other.email == email &&
        other.name == name &&
        other.phone == phone &&
        other.birthday == birthday;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        seller.hashCode ^
        email.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        birthday.hashCode;
  }
}
