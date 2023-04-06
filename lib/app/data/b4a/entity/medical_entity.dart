import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/medical_model.dart';
import 'user_profile_entity.dart';

class MedicalEntity {
  static const String className = 'Medical';
  // Nome do campo local =  no Database
  static const String id = 'objectId';
  static const String seller = 'seller';
  static const String email = 'email';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String crm = 'crm';
  static const String birthday = 'birthday';
  static const String description = 'description';
  static const String isBlocked = 'isBlocked';
  static const String isDeleted = 'isDeleted';

  MedicalModel toModel(ParseObject parseObject) {
    MedicalModel model = MedicalModel(
      id: parseObject.objectId!,
      seller: parseObject.get(MedicalEntity.seller) != null
          ? UserProfileEntity().fromParse(parseObject.get(MedicalEntity.seller))
          : null,
      email: parseObject.get(MedicalEntity.email),
      name: parseObject.get(MedicalEntity.name),
      phone: parseObject.get(MedicalEntity.phone),
      crm: parseObject.get(MedicalEntity.crm),
      birthday: parseObject.get<DateTime>(MedicalEntity.birthday)?.toLocal(),
      description: parseObject.get(MedicalEntity.description),
      isBlocked: parseObject.get(MedicalEntity.isBlocked),
    );
    return model;
  }

  Future<ParseObject> toParse(MedicalModel model) async {
    final parseObject = ParseObject(MedicalEntity.className);
    parseObject.objectId = model.id;

    if (model.seller != null) {
      parseObject.set(
          MedicalEntity.seller,
          (ParseObject(UserProfileEntity.className)
                ..objectId = model.seller!.id)
              .toPointer());
    }
    if (model.email != null) {
      parseObject.set(MedicalEntity.email, model.email);
    }

    if (model.name != null) {
      parseObject.set(MedicalEntity.name, model.name);
    }

    if (model.phone != null) {
      parseObject.set(MedicalEntity.phone, model.phone);
    }
    if (model.crm != null) {
      parseObject.set(MedicalEntity.crm, model.crm);
    }
    if (model.birthday != null) {
      parseObject.set<DateTime?>(MedicalEntity.birthday, model.birthday);
    }
    if (model.description != null) {
      parseObject.set(MedicalEntity.description, model.description);
    }
    if (model.isBlocked != null) {
      parseObject.set(MedicalEntity.isBlocked, model.isBlocked);
    }
    return parseObject;
  }
}
