import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/secretary_model.dart';
import 'user_profile_entity.dart';

class SecretaryEntity {
  static const String className = 'Secretary';
  // Nome do campo local =  no Database
  static const String id = 'objectId';
  static const String seller = 'seller';
  static const String email = 'email';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String birthday = 'birthday';
  static const String isDeleted = 'isDeleted';

  SecretaryModel toModel(ParseObject parseObject) {
    SecretaryModel model = SecretaryModel(
      id: parseObject.objectId!,
      seller: parseObject.get(SecretaryEntity.seller) != null
          ? UserProfileEntity()
              .fromParse(parseObject.get(SecretaryEntity.seller))
          : null,
      email: parseObject.get(SecretaryEntity.email),
      name: parseObject.get(SecretaryEntity.name),
      phone: parseObject.get(SecretaryEntity.phone),
      birthday: parseObject.get<DateTime>(SecretaryEntity.birthday)?.toLocal(),
    );
    return model;
  }

  Future<ParseObject> toParse(SecretaryModel model) async {
    final parseObject = ParseObject(SecretaryEntity.className);
    parseObject.objectId = model.id;

    if (model.seller != null) {
      parseObject.set(
          SecretaryEntity.seller,
          (ParseObject(UserProfileEntity.className)
                ..objectId = model.seller!.id)
              .toPointer());
    }
    if (model.email != null) {
      parseObject.set(SecretaryEntity.email, model.email);
    }

    if (model.name != null) {
      parseObject.set(SecretaryEntity.name, model.name);
    }

    if (model.phone != null) {
      parseObject.set(SecretaryEntity.phone, model.phone);
    }
    if (model.birthday != null) {
      parseObject.set<DateTime?>(
          SecretaryEntity.birthday,
          DateTime(model.birthday!.year, model.birthday!.month,
              model.birthday!.day));
    }

    return parseObject;
  }
}
