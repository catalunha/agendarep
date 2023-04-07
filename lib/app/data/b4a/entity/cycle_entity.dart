import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/cycle_model.dart';
import 'user_profile_entity.dart';

class CycleEntity {
  static const String className = 'Cycle';
  // Nome do campo local =  no Database
  static const String id = 'objectId';
  static const String seller = 'seller';
  static const String name = 'name';
  static const String start = 'start';
  static const String end = 'end';
  static const String isArchived = 'isArchived';
  static const String isDeleted = 'isDeleted';
  CycleModel toModel(ParseObject parseObject) {
    CycleModel model = CycleModel(
      id: parseObject.objectId!,
      seller: parseObject.get(CycleEntity.seller) != null
          ? UserProfileEntity().fromParse(parseObject.get(CycleEntity.seller))
          : null,
      name: parseObject.get(CycleEntity.name),
      start: parseObject.get<DateTime>(CycleEntity.start)?.toLocal(),
      end: parseObject.get<DateTime>(CycleEntity.end)?.toLocal(),
      isArchived: parseObject.get(CycleEntity.isArchived),
    );
    return model;
  }

  Future<ParseObject> toParse(CycleModel model) async {
    final parseObject = ParseObject(CycleEntity.className);
    parseObject.objectId = model.id;
    if (model.seller != null) {
      parseObject.set(
          CycleEntity.seller,
          (ParseObject(UserProfileEntity.className)
                ..objectId = model.seller!.id)
              .toPointer());
    }
    if (model.name != null) {
      parseObject.set(CycleEntity.name, model.name);
    }
    if (model.start != null) {
      parseObject.set<DateTime?>(CycleEntity.start, model.start);
    }
    if (model.end != null) {
      parseObject.set<DateTime?>(CycleEntity.end, model.end);
    }

    if (model.isArchived != null) {
      parseObject.set(CycleEntity.isArchived, model.isArchived);
    }
    return parseObject;
  }
}
