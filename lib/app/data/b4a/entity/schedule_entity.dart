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
  static const String mondayHours = 'mondayHours';
  static const String tuesdayHours = 'tuesdayHours';
  static const String wednesdayHours = 'wednesdayHours';
  static const String thursdayHours = 'thursdayHours';
  static const String fridayHours = 'fridayHours';
  static const String saturdayHours = 'saturdayHours';
  static const String sundayHours = 'sundayHours';
  static const String description = 'description';

  Future<ScheduleModel> toModel(ParseObject parseObject) async {
    print(
        '>>>>> ${parseObject.get<List<dynamic>>(ScheduleEntity.mondayHours)}');
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
      mondayHours:
          parseObject.get<List<dynamic>>(ScheduleEntity.mondayHours) != null
              ? parseObject
                  .get<List<dynamic>>(ScheduleEntity.mondayHours)!
                  .map<int>((e) => e)
                  .toList()
              : [],
      tuesdayHours:
          parseObject.get<List<dynamic>>(ScheduleEntity.tuesdayHours) != null
              ? parseObject
                  .get<List<dynamic>>(ScheduleEntity.tuesdayHours)!
                  .map<int>((e) => e)
                  .toList()
              : [],
      wednesdayHours:
          parseObject.get<List<dynamic>>(ScheduleEntity.wednesdayHours) != null
              ? parseObject
                  .get<List<dynamic>>(ScheduleEntity.wednesdayHours)!
                  .map<int>((e) => e)
                  .toList()
              : [],
      thursdayHours:
          parseObject.get<List<dynamic>>(ScheduleEntity.thursdayHours) != null
              ? parseObject
                  .get<List<dynamic>>(ScheduleEntity.thursdayHours)!
                  .map<int>((e) => e)
                  .toList()
              : [],
      fridayHours:
          parseObject.get<List<dynamic>>(ScheduleEntity.fridayHours) != null
              ? parseObject
                  .get<List<dynamic>>(ScheduleEntity.fridayHours)!
                  .map<int>((e) => e)
                  .toList()
              : [],
      saturdayHours:
          parseObject.get<List<dynamic>>(ScheduleEntity.saturdayHours) != null
              ? parseObject
                  .get<List<dynamic>>(ScheduleEntity.saturdayHours)!
                  .map<int>((e) => e)
                  .toList()
              : [],
      sundayHours:
          parseObject.get<List<dynamic>>(ScheduleEntity.sundayHours) != null
              ? parseObject
                  .get<List<dynamic>>(ScheduleEntity.sundayHours)!
                  .map<int>((e) => e)
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

    if (model.mondayHours != null) {
      parseObject.set(ScheduleEntity.mondayHours, model.mondayHours);
    }
    if (model.tuesdayHours != null) {
      parseObject.set(ScheduleEntity.tuesdayHours, model.tuesdayHours);
    }
    if (model.wednesdayHours != null) {
      parseObject.set(ScheduleEntity.wednesdayHours, model.wednesdayHours);
    }
    if (model.thursdayHours != null) {
      parseObject.set(ScheduleEntity.thursdayHours, model.thursdayHours);
    }
    if (model.fridayHours != null) {
      parseObject.set(ScheduleEntity.fridayHours, model.fridayHours);
    }
    if (model.saturdayHours != null) {
      parseObject.set(ScheduleEntity.saturdayHours, model.saturdayHours);
    }
    if (model.sundayHours != null) {
      parseObject.set(ScheduleEntity.sundayHours, model.sundayHours);
    }
    if (model.description != null) {
      parseObject.set(ScheduleEntity.description, model.description);
    }
    return parseObject;
  }
}
