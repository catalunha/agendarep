import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/secretary_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/secretary_model.dart';

class SecretaryRepository {
  final SecretaryB4a secretaryB4a = SecretaryB4a();

  SecretaryRepository();
  Future<List<SecretaryModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) =>
      secretaryB4a.list(query, pagination);
  Future<String> update(SecretaryModel model) => secretaryB4a.update(model);
  // Future<SecretaryModel?> readById(String id) => SecretaryB4a.readById(id);
  // Future<SecretaryModel?> readByCPF(String? value) =>
  //     SecretaryB4a.readByCPF(value);
}
