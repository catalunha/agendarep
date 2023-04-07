import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/address_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/address_model.dart';

class AddressRepository {
  final AddressB4a addressB4a = AddressB4a();

  AddressRepository();
  Future<List<AddressModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) =>
      addressB4a.list(query, pagination);
  Future<String> update(AddressModel model) => addressB4a.update(model);
  Future<bool> delete(String modelId) => addressB4a.delete(modelId);
}
