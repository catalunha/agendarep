import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/region_model.dart';
import 'user_profile_entity.dart';

class RegionEntity {
  static const String className = 'Region';
  // Nome do campo local =  no Database
  static const String id = 'objectId';
  static const String seller = 'seller';
  static const String uf = 'uf';
  static const String city = 'city';
  static const String name = 'name';
  static const String isDeleted = 'isDeleted';
  RegionModel toModel(ParseObject parseObject) {
    RegionModel model = RegionModel(
      id: parseObject.objectId!,
      seller: parseObject.get(RegionEntity.seller) != null
          ? UserProfileEntity().fromParse(parseObject.get(RegionEntity.seller))
          : null,
      uf: parseObject.get(RegionEntity.uf),
      city: parseObject.get(RegionEntity.city),
      name: parseObject.get(RegionEntity.name),
    );
    return model;
  }

  Future<ParseObject> toParse(RegionModel model) async {
    final parseObject = ParseObject(RegionEntity.className);
    parseObject.objectId = model.id;
    if (model.seller != null) {
      parseObject.set(
          RegionEntity.seller,
          (ParseObject(UserProfileEntity.className)
                ..objectId = model.seller!.id)
              .toPointer());
    }
    if (model.uf != null) {
      parseObject.set(RegionEntity.uf, model.uf);
    }
    if (model.city != null) {
      parseObject.set(RegionEntity.city, model.city);
    }
    if (model.name != null) {
      parseObject.set(RegionEntity.name, model.name);
    }

    return parseObject;
  }
}
