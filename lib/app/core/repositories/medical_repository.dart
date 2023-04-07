import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/medical_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/medical_model.dart';

class MedicalRepository {
  final MedicalB4a secretaryB4a = MedicalB4a();

  MedicalRepository();
  Future<List<MedicalModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) =>
      secretaryB4a.list(query, pagination);
  Future<String> update(MedicalModel model) => secretaryB4a.update(model);
  Future<bool> delete(String modelId) => secretaryB4a.delete(modelId);
  Future<void> updateRelationExpertises(
          String objectId, List<String> ids, bool add) =>
      secretaryB4a.updateRelationExpertises(
          objectId: objectId, ids: ids, add: add);
}
