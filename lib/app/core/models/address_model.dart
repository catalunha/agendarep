import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'package:agendarep/app/core/models/region_model.dart';

import 'user_profile_model.dart';

class AddressModel {
  final String? id;
  final UserProfileModel? seller;
  final String? name;
  final String? phone;
  final String? description;
  final ParseGeoPoint? parseGeoPoint;
  final RegionModel? region;
  AddressModel({
    this.id,
    this.seller,
    this.name,
    this.phone,
    this.description,
    this.parseGeoPoint,
    this.region,
  });

  AddressModel copyWith({
    String? id,
    UserProfileModel? seller,
    String? name,
    String? phone,
    String? description,
    ParseGeoPoint? parseGeoPoint,
    RegionModel? region,
  }) {
    return AddressModel(
      id: id ?? this.id,
      seller: seller ?? this.seller,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      parseGeoPoint: parseGeoPoint ?? this.parseGeoPoint,
      region: region ?? this.region,
    );
  }

  @override
  String toString() {
    return 'AddressModel(id: $id, seller: $seller, name: $name, phone: $phone, description: $description, parseGeoPoint: $parseGeoPoint, region: $region)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressModel &&
        other.id == id &&
        other.seller == seller &&
        other.name == name &&
        other.phone == phone &&
        other.description == description &&
        other.parseGeoPoint == parseGeoPoint &&
        other.region == region;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        seller.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        description.hashCode ^
        parseGeoPoint.hashCode ^
        region.hashCode;
  }
}
