import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/expertise_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/expertise_model.dart';

class ExpertiseRepository {
  final ExpertiseB4a expertiseB4a = ExpertiseB4a();

  ExpertiseRepository();
  Future<List<ExpertiseModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) =>
      expertiseB4a.list(query, pagination);
  // Future<String> update(ExpertiseModel model) => expertiseB4a.update(model);
  // Future<bool> delete(String modelId) => expertiseB4a.delete(modelId);
}
