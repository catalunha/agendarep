import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/address_model.dart';
import 'region_entity.dart';
import 'user_profile_entity.dart';

class AddressEntity {
  static const String className = 'Address';
  // Nome do campo local =  no Database
  static const String id = 'objectId';
  static const String seller = 'seller';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String description = 'description';
  static const String parseGeoPoint = 'parseGeoPoint';
  static const String region = 'region';

  AddressModel toModel(ParseObject parseObject) {
    print('parseObjectobjectId: ${parseObject.objectId}');
    print('parseObject: $parseObject');
    if (parseObject.get(AddressEntity.region) != null) {
      print('region: ${parseObject.get(AddressEntity.region)}');
      print(
          'regionModel: ${RegionEntity().toModel(parseObject.get(AddressEntity.region))}');
    }
    if (parseObject.get(AddressEntity.seller) != null) {
      print('seller: ${parseObject.get(AddressEntity.seller)}');
    }
    AddressModel model = AddressModel(
      id: parseObject.objectId!,
      seller: parseObject.get(AddressEntity.seller) != null
          ? UserProfileEntity().fromParse(parseObject.get(AddressEntity.seller))
          : null,
      name: parseObject.get(AddressEntity.name),
      phone: parseObject.get(AddressEntity.phone),
      description: parseObject.get(AddressEntity.description),
      parseGeoPoint: parseObject.get(AddressEntity.parseGeoPoint),
      region: parseObject.get(AddressEntity.region) != null
          ? RegionEntity().toModel(parseObject.get(AddressEntity.region))
          : null,
    );
    return model;
  }

  Future<ParseObject> toParse(AddressModel model) async {
    final parseObject = ParseObject(AddressEntity.className);
    parseObject.objectId = model.id;

    if (model.seller != null) {
      parseObject.set(
          AddressEntity.seller,
          (ParseObject(UserProfileEntity.className)
                ..objectId = model.seller!.id)
              .toPointer());
    }

    if (model.name != null) {
      parseObject.set(AddressEntity.name, model.name);
    }
    if (model.phone != null) {
      parseObject.set(AddressEntity.phone, model.phone);
    }
    if (model.description != null) {
      parseObject.set(AddressEntity.description, model.description);
    }
    if (model.parseGeoPoint != null) {
      parseObject.set(AddressEntity.parseGeoPoint, model.parseGeoPoint);
    }
    if (model.region != null) {
      parseObject.set(
          AddressEntity.region,
          (ParseObject(RegionEntity.className)..objectId = model.region!.id)
              .toPointer());
    }
    return parseObject;
  }
}
