import 'dart:convert';

import 'package:agendarep/app/core/models/user_profile_model.dart';

class SecretaryModel {
  final String? id;
  final UserProfileModel? seller;
  final String? email;
  final String? name;
  final String? phone;
  final DateTime? birthday;
  final String? description;
  SecretaryModel({
    this.id,
    this.seller,
    this.email,
    this.name,
    this.phone,
    this.birthday,
    this.description,
  });

  SecretaryModel copyWith({
    String? id,
    UserProfileModel? seller,
    String? email,
    String? name,
    String? phone,
    DateTime? birthday,
    String? description,
  }) {
    return SecretaryModel(
      id: id ?? this.id,
      seller: seller ?? this.seller,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (seller != null) {
      result.addAll({'seller': seller!.toMap()});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (phone != null) {
      result.addAll({'phone': phone});
    }
    if (birthday != null) {
      result.addAll({'birthday': birthday!.millisecondsSinceEpoch});
    }
    if (description != null) {
      result.addAll({'description': description});
    }

    return result;
  }

  factory SecretaryModel.fromMap(Map<String, dynamic> map) {
    return SecretaryModel(
      id: map['id'],
      seller: map['seller'] != null
          ? UserProfileModel.fromMap(map['seller'])
          : null,
      email: map['email'],
      name: map['name'],
      phone: map['phone'],
      birthday: map['birthday'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['birthday'])
          : null,
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SecretaryModel.fromJson(String source) =>
      SecretaryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SecretaryModel(id: $id, seller: $seller, email: $email, name: $name, phone: $phone, birthday: $birthday, description: $description)';
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
        other.birthday == birthday &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        seller.hashCode ^
        email.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        birthday.hashCode ^
        description.hashCode;
  }
}
