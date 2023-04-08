import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/clinic_model.dart';
import '../../../core/models/secretary_model.dart';
import 'address_entity.dart';
import 'medical_entity.dart';
import 'secretary_entity.dart';
import 'user_profile_entity.dart';

class ClinicEntity {
  static const String className = 'Clinic';
  // Nome do campo local =  no Database
  static const String id = 'objectId';
  static const String seller = 'seller';
  static const String medical = 'medical';
  static const String address = 'address';
  static const String secretaries = 'secretaries';
  static const String name = 'name';
  static const String room = 'room';
  static const String phone = 'phone';
  static const String isDeleted = 'isDeleted';

  Future<ClinicModel> toModel(ParseObject parseObject) async {
    //+++ get secretary
    List<SecretaryModel> secretaryList = [];
    QueryBuilder<ParseObject> querySecretary =
        QueryBuilder<ParseObject>(ParseObject(SecretaryEntity.className));
    querySecretary.whereRelatedTo(ClinicEntity.secretaries,
        ClinicEntity.className, parseObject.objectId!);
    querySecretary.includeObject(['seller']);
    final ParseResponse parseResponse = await querySecretary.query();
    if (parseResponse.success && parseResponse.results != null) {
      for (var e in parseResponse.results!) {
        secretaryList.add(SecretaryEntity().toModel(e as ParseObject));
      }
    }
    //--- get secretary

    ClinicModel model = ClinicModel(
      id: parseObject.objectId!,
      seller: parseObject.get(ClinicEntity.seller) != null
          ? UserProfileEntity().fromParse(parseObject.get(ClinicEntity.seller))
          : null,
      medical: parseObject.get(ClinicEntity.medical) != null
          ? await MedicalEntity().toModel(parseObject.get(ClinicEntity.medical))
          : null,
      address: parseObject.get(ClinicEntity.address) != null
          ? AddressEntity().toModel(parseObject.get(ClinicEntity.address))
          : null,
      secretaries: secretaryList,
      name: parseObject.get(ClinicEntity.name),
      room: parseObject.get(ClinicEntity.room),
      phone: parseObject.get(ClinicEntity.phone),
    );
    return model;
  }

  Future<ParseObject> toParse(ClinicModel model) async {
    final parseObject = ParseObject(ClinicEntity.className);
    parseObject.objectId = model.id;

    if (model.seller != null) {
      parseObject.set(
          ClinicEntity.seller,
          (ParseObject(UserProfileEntity.className)
                ..objectId = model.seller!.id)
              .toPointer());
    }
    if (model.medical != null) {
      parseObject.set(
          ClinicEntity.medical,
          (ParseObject(MedicalEntity.className)..objectId = model.medical!.id)
              .toPointer());
    }
    if (model.address != null) {
      parseObject.set(
          ClinicEntity.address,
          (ParseObject(AddressEntity.className)..objectId = model.address!.id)
              .toPointer());
    }
    if (model.name != null) {
      parseObject.set(ClinicEntity.name, model.name);
    }
    if (model.room != null) {
      parseObject.set(ClinicEntity.room, model.room);
    }
    if (model.phone != null) {
      parseObject.set(ClinicEntity.phone, model.phone);
    }

    return parseObject;
  }

  ParseObject? toParseRelationSecretaries({
    required String objectId,
    required List<String> ids,
    required bool add,
  }) {
    final parseObject = ParseObject(ClinicEntity.className);
    parseObject.objectId = objectId;
    if (ids.isEmpty) {
      parseObject.unset(ClinicEntity.secretaries);
      return parseObject;
    }
    if (add) {
      parseObject.addRelation(
        ClinicEntity.secretaries,
        ids
            .map(
              (element) =>
                  ParseObject(SecretaryEntity.className)..objectId = element,
            )
            .toList(),
      );
    } else {
      parseObject.removeRelation(
          ClinicEntity.secretaries,
          ids
              .map((element) =>
                  ParseObject(SecretaryEntity.className)..objectId = element)
              .toList());
    }
    return parseObject;
  }
}
