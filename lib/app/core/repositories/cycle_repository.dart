import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/cycle_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/cycle_model.dart';

class CycleRepository {
  final CycleB4a secretaryB4a = CycleB4a();

  CycleRepository();
  Future<List<CycleModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) =>
      secretaryB4a.list(query, pagination);
  Future<String> update(CycleModel model) => secretaryB4a.update(model);
  Future<bool> delete(String modelId) => secretaryB4a.delete(modelId);
}
