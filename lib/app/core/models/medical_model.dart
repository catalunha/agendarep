import 'dart:convert';

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
  final String? description;
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
    this.description,
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
    String? description,
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
      description: description ?? this.description,
      isBlocked: isBlocked ?? this.isBlocked,
      expertises: expertises ?? this.expertises,
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
    if (crm != null) {
      result.addAll({'crm': crm});
    }
    if (birthday != null) {
      result.addAll({'birthday': birthday!.millisecondsSinceEpoch});
    }
    if (description != null) {
      result.addAll({'description': description});
    }
    if (isBlocked != null) {
      result.addAll({'isBlocked': isBlocked});
    }
    if (expertises != null) {
      result.addAll({'expertises': expertises!.map((x) => x.toMap()).toList()});
    }

    return result;
  }

  factory MedicalModel.fromMap(Map<String, dynamic> map) {
    return MedicalModel(
      id: map['id'],
      seller: map['seller'] != null
          ? UserProfileModel.fromMap(map['seller'])
          : null,
      email: map['email'],
      name: map['name'],
      phone: map['phone'],
      crm: map['crm'],
      birthday: map['birthday'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['birthday'])
          : null,
      description: map['description'],
      isBlocked: map['isBlocked'],
      expertises: map['expertises'] != null
          ? List<ExpertiseModel>.from(
              map['expertises']?.map((x) => ExpertiseModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicalModel.fromJson(String source) =>
      MedicalModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MedicalModel(id: $id, seller: $seller, email: $email, name: $name, phone: $phone, crm: $crm, birthday: $birthday, description: $description, isBlocked: $isBlocked, expertises: $expertises)';
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
        other.description == description &&
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
        description.hashCode ^
        isBlocked.hashCode ^
        expertises.hashCode;
  }
}
