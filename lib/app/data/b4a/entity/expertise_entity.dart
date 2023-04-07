import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/expertise_model.dart';

class ExpertiseEntity {
  static const String className = 'Expertise';
  static const String id = 'objectId';
  static const String code = 'code';
  static const String name = 'name';

  ExpertiseModel toModel(ParseObject parseUser) {
    return ExpertiseModel(
      id: parseUser.objectId!,
      code: parseUser.get(ExpertiseEntity.code),
      name: parseUser.get(ExpertiseEntity.name),
    );
  }
}
