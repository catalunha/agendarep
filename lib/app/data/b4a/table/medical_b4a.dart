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
      QueryBuilder<ParseObject> query, Pagination pagination,
      [List<String> includeRelation = const []]) async {
    QueryBuilder<ParseObject> query2;
    query2 = await getQueryAll(query, pagination);
    ParseResponse? parseResponse;
    try {
      parseResponse = await query2.query();
      List<MedicalModel> listTemp = <MedicalModel>[];
      if (parseResponse.success && parseResponse.results != null) {
        for (var element in parseResponse.results!) {
          listTemp.add(await MedicalEntity().toModel(element, includeRelation));
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

  Future<void> updateRelationExpertises(
      {required String objectId,
      required List<String> ids,
      required bool add}) async {
    final parseObject = MedicalEntity()
        .toParseRelationExpertises(objectId: objectId, ids: ids, add: add);
    if (parseObject != null) {
      await parseObject.save();
    }
  }
}
