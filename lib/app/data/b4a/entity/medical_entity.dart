import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/expertise_model.dart';
import '../../../core/models/medical_model.dart';
import 'expertise_entity.dart';
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
  static const String isBlocked = 'isBlocked';
  static const String isDeleted = 'isDeleted';
  static const String expertises = 'expertises';

  Future<MedicalModel> toModel(ParseObject parseObject) async {
    print('crm: ${parseObject.containsKey('crm')}');
    print('expertises: ${parseObject.containsKey('expertises')}');
    //+++ get expertise
    List<ExpertiseModel> expertiseList = [];
    QueryBuilder<ParseObject> queryExpertise =
        QueryBuilder<ParseObject>(ParseObject(ExpertiseEntity.className));
    queryExpertise.whereRelatedTo(MedicalEntity.expertises,
        MedicalEntity.className, parseObject.objectId!);
    final ParseResponse parseResponse = await queryExpertise.query();
    if (parseResponse.success && parseResponse.results != null) {
      for (var e in parseResponse.results!) {
        expertiseList.add(ExpertiseEntity().toModel(e as ParseObject));
      }
    }
    //--- get expertise

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
      isBlocked: parseObject.get(MedicalEntity.isBlocked),
      expertises: expertiseList,
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

    if (model.isBlocked != null) {
      parseObject.set(MedicalEntity.isBlocked, model.isBlocked);
    }
    return parseObject;
  }

  ParseObject? toParseRelationExpertises({
    required String objectId,
    required List<String> ids,
    required bool add,
  }) {
    final parseObject = ParseObject(MedicalEntity.className);
    parseObject.objectId = objectId;
    if (ids.isEmpty) {
      parseObject.unset(MedicalEntity.expertises);
      return parseObject;
    }
    if (add) {
      parseObject.addRelation(
        MedicalEntity.expertises,
        ids
            .map(
              (element) =>
                  ParseObject(ExpertiseEntity.className)..objectId = element,
            )
            .toList(),
      );
    } else {
      parseObject.removeRelation(
          MedicalEntity.expertises,
          ids
              .map((element) =>
                  ParseObject(ExpertiseEntity.className)..objectId = element)
              .toList());
    }
    return parseObject;
  }
}
