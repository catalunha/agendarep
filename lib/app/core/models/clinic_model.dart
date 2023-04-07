import 'package:flutter/foundation.dart';

import 'address_model.dart';
import 'medical_model.dart';
import 'secretary_model.dart';
import 'user_profile_model.dart';

class ClinicModel {
  final String? id;
  final UserProfileModel? seller;
  final MedicalModel? medical;
  final AddressModel? address;
  final List<SecretaryModel>? secretaries;
  final String? room;
  final String? phone;
  final String? description;
  ClinicModel({
    this.id,
    this.seller,
    this.medical,
    this.address,
    this.secretaries,
    this.room,
    this.phone,
    this.description,
  });

  ClinicModel copyWith({
    String? id,
    UserProfileModel? seller,
    MedicalModel? medical,
    AddressModel? address,
    List<SecretaryModel>? secretaries,
    String? room,
    String? phone,
    String? description,
  }) {
    return ClinicModel(
      id: id ?? this.id,
      seller: seller ?? this.seller,
      medical: medical ?? this.medical,
      address: address ?? this.address,
      secretaries: secretaries ?? this.secretaries,
      room: room ?? this.room,
      phone: phone ?? this.phone,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'ClinicModel(id: $id, seller: $seller, medical: $medical, address: $address, secretaries: $secretaries, room: $room, phone: $phone, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClinicModel &&
        other.id == id &&
        other.seller == seller &&
        other.medical == medical &&
        other.address == address &&
        listEquals(other.secretaries, secretaries) &&
        other.room == room &&
        other.phone == phone &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        seller.hashCode ^
        medical.hashCode ^
        address.hashCode ^
        secretaries.hashCode ^
        room.hashCode ^
        phone.hashCode ^
        description.hashCode;
  }
}
