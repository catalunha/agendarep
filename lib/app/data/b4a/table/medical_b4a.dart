import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/medical_model.dart';
import '../../utils/pagination.dart';
import '../b4a_exception.dart';
import '../entity/medical_entity.dart';
import '../utils/parse_error_translate.dart';

class MedicalB4a {
  Future<QueryBuilder<ParseObject>> getQueryAll(
      QueryBuilder<ParseObject> query, Pagination pagination) async {
    query.setAmountToSkip((pagination.page - 1) * pagination.limit);
    query.setLimit(pagination.limit);
    query.whereEqualTo(MedicalEntity.isDeleted, false);
    query.includeObject(['seller']);
    return query;
  }

  Future<List<MedicalModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) async {
    QueryBuilder<ParseObject> query2;
    query2 = await getQueryAll(query, pagination);
    ParseResponse? parseResponse;
    try {
      parseResponse = await query2.query();
      List<MedicalModel> listTemp = <MedicalModel>[];
      if (parseResponse.success && parseResponse.results != null) {
        for (var element in parseResponse.results!) {
          listTemp.add(MedicalEntity().toModel(element));
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
        where: 'MedicalRepositoryB4a.list',
        originalError:
            '${parseResponse.error!.code} -${parseResponse.error!.message}',
      );
    }
  }

  // Future<MedicalModel?> readById(String id) async {
  //   QueryBuilder<ParseObject> query =
  //       QueryBuilder<ParseObject>(ParseObject(MedicalEntity.className));
  //   query.whereEqualTo(MedicalEntity.id, id);
  //   query.first();
  //   try {
  //     var parseResponse = await query.query();

  //     if (parseResponse.success && parseResponse.results != null) {
  //       return MedicalEntity().toModel(parseResponse.results!.first);
  //     }
  //     throw B4aException(
  //       'Perfil do usuário não encontrado.',
  //       where: 'MedicalRepositoryB4a.readById()',
  //     );
  //   } catch (_) {
  //     rethrow;
  //   }
  // }

  Future<String> update(MedicalModel model) async {
    final parseObject = await MedicalEntity().toParse(model);
    ParseResponse? parseResponse;
    try {
      parseResponse = await parseObject.save();

      if (parseResponse.success && parseResponse.results != null) {
        ParseObject parseObjectItem =
            parseResponse.results!.first as ParseObject;
        return parseObjectItem.objectId!;
      } else {
        throw Exception();
      }
    } on Exception {
      var errorTranslated =
          ParseErrorTranslate.translate(parseResponse!.error!);
      throw B4aException(
        errorTranslated,
        where: 'MedicalRepositoryB4a.update',
        originalError:
            '${parseResponse.error!.code} -${parseResponse.error!.message}',
      );
    }
  }

  Future<bool> delete(String modelId) async {
    final parseObject = ParseObject(MedicalEntity.className);
    parseObject.objectId = modelId;
    parseObject.set(MedicalEntity.isDeleted, true);
    ParseResponse? parseResponse;

    try {
      parseResponse = await parseObject.save();
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
        where: 'MedicalRepositoryB4a.update',
        originalError:
            '${parseResponse.error!.code} -${parseResponse.error!.message}',
      );
    }
  }
  // Future<MedicalModel?> readByCPF(String? value) async {
  //   QueryBuilder<ParseObject> query =
  //       QueryBuilder<ParseObject>(ParseObject(MedicalEntity.className));
  //   query.whereEqualTo(MedicalEntity.cpf, value);

  //   query.first();
  //   ParseResponse? parseResponse;
  //   try {
  //     parseResponse = await query.query();

  //     if (parseResponse.success && parseResponse.results != null) {
  //       return MedicalEntity().toModel(parseResponse.results!.first);
  //     } else {
  //       // throw Exception();
  //       return null;
  //     }
  //   } on Exception {
  //     var errorTranslated = ParseErrorTranslate.translate(parseResponse!.error!);
  //     throw B4aException(
  //       errorTranslated,
  //       where: 'MedicalRepositoryB4a.getByRegister',
  //       originalError: '${parseResponse.error!.code} -${parseResponse.error!.message}',
  //     );
  //   }
  // }
}
