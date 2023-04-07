import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/clinic_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/clinic_model.dart';

class ClinicRepository {
  final ClinicB4a clinicB4a = ClinicB4a();

  ClinicRepository();
  Future<List<ClinicModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) =>
      clinicB4a.list(query, pagination);
  Future<String> update(ClinicModel model) => clinicB4a.update(model);
  Future<bool> delete(String modelId) => clinicB4a.delete(modelId);
  Future<void> updateRelationSecretaries(
          String objectId, List<String> ids, bool add) =>
      clinicB4a.updateRelationSecretaries(
          objectId: objectId, ids: ids, add: add);
}
