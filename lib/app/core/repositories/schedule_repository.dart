import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/schedule_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/schedule_models.dart';

class ScheduleRepository {
  final ScheduleB4a scheduleB4a = ScheduleB4a();

  ScheduleRepository();
  Future<List<ScheduleModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) =>
      scheduleB4a.list(query, pagination);
  Future<String> update(ScheduleModel model) => scheduleB4a.update(model);
  Future<bool> delete(String modelId) => scheduleB4a.delete(modelId);
}
