import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/schedule_models.dart';
import 'clinic_entity.dart';
import 'expertise_entity.dart';
import 'medical_entity.dart';
import 'user_profile_entity.dart';

class ScheduleEntity {
  static const String className = 'Schedule';
  // Nome do campo local =  no Database
  static const String id = 'objectId';
  static const String seller = 'seller';
  static const String medical = 'medical';
  static const String expertise = 'expertise';
  static const String clinic = 'clinic';
  static const String justSchedule = 'justSchedule';
  static const String limitedSellers = 'limitedSellers';
  static const String weekday = 'weekday';
  static const String hour = 'hour';
  static const String description = 'description';
  static const String isDeleted = 'isDeleted';

  Future<ScheduleModel> toModel(ParseObject parseObject) async {
    ScheduleModel model = ScheduleModel(
      id: parseObject.objectId!,
      seller: parseObject.get(ScheduleEntity.seller) != null
          ? UserProfileEntity()
              .fromParse(parseObject.get(ScheduleEntity.seller))
          : null,
      medical: parseObject.get(ScheduleEntity.medical) != null
          ? await MedicalEntity()
              .toModel(parseObject.get(ScheduleEntity.medical))
          : null,
      expertise: parseObject.get(ScheduleEntity.expertise) != null
          ? ExpertiseEntity().toModel(parseObject.get(ScheduleEntity.expertise))
          : null,
      clinic: parseObject.get(ScheduleEntity.clinic) != null
          ? await ClinicEntity().toModel(parseObject.get(ScheduleEntity.clinic))
          : null,
      justSchedule: parseObject.get(ScheduleEntity.justSchedule),
      limitedSellers: parseObject.get(ScheduleEntity.limitedSellers),
      weekday: parseObject.get(ScheduleEntity.weekday),
      hour: parseObject.get<List<dynamic>>(ScheduleEntity.hour) != null
          ? parseObject
              .get<List<int>>(ScheduleEntity.hour)!
              .map((e) => e)
              .toList()
          : [],
      description: parseObject.get(ScheduleEntity.description),
    );
    return model;
  }

  Future<ParseObject> toParse(ScheduleModel model) async {
    final parseObject = ParseObject(ScheduleEntity.className);
    parseObject.objectId = model.id;

    if (model.seller != null) {
      parseObject.set(
          ScheduleEntity.seller,
          (ParseObject(UserProfileEntity.className)
                ..objectId = model.seller!.id)
              .toPointer());
    }
    if (model.medical != null) {
      parseObject.set(
          ScheduleEntity.medical,
          (ParseObject(MedicalEntity.className)..objectId = model.medical!.id)
              .toPointer());
    }
    if (model.expertise != null) {
      parseObject.set(
          ScheduleEntity.expertise,
          (ParseObject(ExpertiseEntity.className)
                ..objectId = model.expertise!.id)
              .toPointer());
    }
    if (model.clinic != null) {
      parseObject.set(
          ScheduleEntity.clinic,
          (ParseObject(ClinicEntity.className)..objectId = model.clinic!.id)
              .toPointer());
    }
    if (model.justSchedule != null) {
      parseObject.set(ScheduleEntity.justSchedule, model.justSchedule);
    }
    if (model.limitedSellers != null) {
      parseObject.set(ScheduleEntity.limitedSellers, model.limitedSellers);
    }
    if (model.weekday != null) {
      parseObject.set(ScheduleEntity.weekday, model.weekday);
    }
    if (model.hour != null) {
      parseObject.set(ScheduleEntity.hour, model.hour);
    }
    if (model.description != null) {
      parseObject.set(ScheduleEntity.description, model.description);
    }
    return parseObject;
  }
}
