import 'package:flutter/foundation.dart';

import 'package:agendarep/app/core/models/expertise_model.dart';

import 'user_profile_model.dart';

class MedicalModel {
  final String? id;
  final UserProfileModel? seller;
  final String? email;
  final String? name;
  final String? phone;
  final String? crm;
  final DateTime? birthday;
  final bool? isBlocked;
  final List<ExpertiseModel>? expertises;

  MedicalModel({
    this.id,
    this.seller,
    this.email,
    this.name,
    this.phone,
    this.crm,
    this.birthday,
    this.isBlocked,
    this.expertises,
  });

  MedicalModel copyWith({
    String? id,
    UserProfileModel? seller,
    String? email,
    String? name,
    String? phone,
    String? crm,
    DateTime? birthday,
    bool? isBlocked,
    List<ExpertiseModel>? expertises,
  }) {
    return MedicalModel(
      id: id ?? this.id,
      seller: seller ?? this.seller,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      crm: crm ?? this.crm,
      birthday: birthday ?? this.birthday,
      isBlocked: isBlocked ?? this.isBlocked,
      expertises: expertises ?? this.expertises,
    );
  }

  @override
  String toString() {
    return 'MedicalModel(id: $id, seller: $seller, email: $email, name: $name, phone: $phone, crm: $crm, birthday: $birthday, isBlocked: $isBlocked, expertises: $expertises)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MedicalModel &&
        other.id == id &&
        other.seller == seller &&
        other.email == email &&
        other.name == name &&
        other.phone == phone &&
        other.crm == crm &&
        other.birthday == birthday &&
        other.isBlocked == isBlocked &&
        listEquals(other.expertises, expertises);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        seller.hashCode ^
        email.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        crm.hashCode ^
        birthday.hashCode ^
        isBlocked.hashCode ^
        expertises.hashCode;
  }
}
