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
    query.includeObject(['seller']);
    return query;
  }

  Future<List<SecretaryModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) async {
    QueryBuilder<ParseObject> query2;
    query2 = await getQueryAll(query, pagination);
    ParseResponse? parseResponse;
    try {
      parseResponse = await query2.query();
      List<SecretaryModel> listTemp = <SecretaryModel>[];
      if (parseResponse.success && parseResponse.results != null) {
        for (var element in parseResponse.results!) {
          listTemp.add(SecretaryEntity().toModel(element));
        }
        return listTemp;
      } else {
        return [];
      }
    } on Exception {
      var errorTranslated =
          ParseErrorTranslate.translate(parseResponse!.error!);
      throw B4aException(
        errorTranslated,
        where: 'SecretaryRepositoryB4a.list',
        originalError:
            '${parseResponse.error!.code} -${parseResponse.error!.message}',
      );
    }
  }

  // Future<SecretaryModel?> readById(String id) async {
  //   QueryBuilder<ParseObject> query =
  //       QueryBuilder<ParseObject>(ParseObject(SecretaryEntity.className));
  //   query.whereEqualTo(SecretaryEntity.id, id);
  //   query.first();
  //   try {
  //     var parseResponse = await query.query();

  //     if (parseResponse.success && parseResponse.results != null) {
  //       return SecretaryEntity().toModel(parseResponse.results!.first);
  //     }
  //     throw B4aException(
  //       'Perfil do usuário não encontrado.',
  //       where: 'SecretaryRepositoryB4a.readById()',
  //     );
  //   } catch (_) {
  //     rethrow;
  //   }
  // }

  Future<String> update(SecretaryModel model) async {
    final parseObject = await SecretaryEntity().toParse(model);
    ParseResponse? parseResponse;
    try {
      parseResponse = await parseObject.save();

      if (parseResponse.success && parseResponse.results != null) {
        ParseObject secretary = parseResponse.results!.first as ParseObject;
        return secretary.objectId!;
      } else {
        throw Exception();
      }
    } on Exception {
      var errorTranslated =
          ParseErrorTranslate.translate(parseResponse!.error!);
      throw B4aException(
        errorTranslated,
        where: 'SecretaryRepositoryB4a.update',
        originalError:
            '${parseResponse.error!.code} -${parseResponse.error!.message}',
      );
    }
  }

  Future<bool> delete(String modelId) async {
    final parseObject = ParseObject(SecretaryEntity.className);
    parseObject.objectId = modelId;
    ParseResponse? parseResponse;

    try {
      parseResponse = await parseObject.delete();
      if (parseResponse.success && parseResponse.results != null) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      var errorTranslated =
          ParseErrorTranslate.translate(parseResponse!.error!);
      throw B4aException(
        errorTranslated,
        where: 'SecretaryRepositoryB4a.update',
        originalError:
            '${parseResponse.error!.code} -${parseResponse.error!.message}',
      );
    }
  }
  // Future<SecretaryModel?> readByCPF(String? value) async {
  //   QueryBuilder<ParseObject> query =
  //       QueryBuilder<ParseObject>(ParseObject(SecretaryEntity.className));
  //   query.whereEqualTo(SecretaryEntity.cpf, value);

  //   query.first();
  //   ParseResponse? parseResponse;
  //   try {
  //     parseResponse = await query.query();

  //     if (parseResponse.success && parseResponse.results != null) {
  //       return SecretaryEntity().toModel(parseResponse.results!.first);
  //     } else {
  //       // throw Exception();
  //       return null;
  //     }
  //   } on Exception {
  //     var errorTranslated = ParseErrorTranslate.translate(parseResponse!.error!);
  //     throw B4aException(
  //       errorTranslated,
  //       where: 'SecretaryRepositoryB4a.getByRegister',
  //       originalError: '${parseResponse.error!.code} -${parseResponse.error!.message}',
  //     );
  //   }
  // }
}
