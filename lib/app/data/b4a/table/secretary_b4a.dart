import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/secretary_model.dart';
import '../../utils/pagination.dart';
import '../b4a_exception.dart';
import '../entity/secretary_entity.dart';
import '../utils/parse_error_translate.dart';

class SecretaryB4a {
  Future<QueryBuilder<ParseObject>> getQueryAll(
      QueryBuilder<ParseObject> query, Pagination pagination) async {
    query.setAmountToSkip((pagination.page - 1) * pagination.limit);
    query.setLimit(pagination.limit);
    query.whereEqualTo(SecretaryEntity.isDeleted, false);
    query.includeObject(['seller']);
    return query;
  }

  Future<List<SecretaryModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) async {
    QueryBuilder<ParseObject> query2;
    query2 = await getQueryAll(query, pagination);
    ParseResponse? response;
    try {
      response = await query2.query();
      List<SecretaryModel> listTemp = <SecretaryModel>[];
      if (response.success && response.results != null) {
        for (var element in response.results!) {
          listTemp.add(SecretaryEntity().toModel(element));
        }
        return listTemp;
      } else {
        return [];
      }
    } on Exception {
      var errorTranslated = ParseErrorTranslate.translate(response!.error!);
      throw B4aException(
        errorTranslated,
        where: 'SecretaryRepositoryB4a.list',
        originalError: '${response.error!.code} -${response.error!.message}',
      );
    }
  }

  // Future<SecretaryModel?> readById(String id) async {
  //   QueryBuilder<ParseObject> query =
  //       QueryBuilder<ParseObject>(ParseObject(SecretaryEntity.className));
  //   query.whereEqualTo(SecretaryEntity.id, id);
  //   query.first();
  //   try {
  //     var response = await query.query();

  //     if (response.success && response.results != null) {
  //       return SecretaryEntity().toModel(response.results!.first);
  //     }
  //     throw B4aException(
  //       'Perfil do usuário não encontrado.',
  //       where: 'SecretaryRepositoryB4a.readById()',
  //     );
  //   } catch (_) {
  //     rethrow;
  //   }
  // }

  Future<String> update(SecretaryModel SecretaryModel) async {
    final SecretaryParse = await SecretaryEntity().toParse(SecretaryModel);
    ParseResponse? response;
    try {
      response = await SecretaryParse.save();

      if (response.success && response.results != null) {
        ParseObject Secretary = response.results!.first as ParseObject;
        return Secretary.objectId!;
      } else {
        throw Exception();
      }
    } on Exception {
      var errorTranslated = ParseErrorTranslate.translate(response!.error!);
      throw B4aException(
        errorTranslated,
        where: 'SecretaryRepositoryB4a.update',
        originalError: '${response.error!.code} -${response.error!.message}',
      );
    }
  }

  // Future<SecretaryModel?> readByCPF(String? value) async {
  //   QueryBuilder<ParseObject> query =
  //       QueryBuilder<ParseObject>(ParseObject(SecretaryEntity.className));
  //   query.whereEqualTo(SecretaryEntity.cpf, value);

  //   query.first();
  //   ParseResponse? response;
  //   try {
  //     response = await query.query();

  //     if (response.success && response.results != null) {
  //       return SecretaryEntity().toModel(response.results!.first);
  //     } else {
  //       // throw Exception();
  //       return null;
  //     }
  //   } on Exception {
  //     var errorTranslated = ParseErrorTranslate.translate(response!.error!);
  //     throw B4aException(
  //       errorTranslated,
  //       where: 'SecretaryRepositoryB4a.getByRegister',
  //       originalError: '${response.error!.code} -${response.error!.message}',
  //     );
  //   }
  // }
}
