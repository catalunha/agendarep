import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/expertise_model.dart';
import '../../utils/pagination.dart';
import '../b4a_exception.dart';
import '../entity/expertise_entity.dart';
import '../utils/parse_error_translate.dart';

class ExpertiseB4a {
  Future<QueryBuilder<ParseObject>> getQueryAll(
      QueryBuilder<ParseObject> query, Pagination pagination) async {
    query.setAmountToSkip((pagination.page - 1) * pagination.limit);
    query.setLimit(pagination.limit);
    return query;
  }

  Future<List<ExpertiseModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) async {
    QueryBuilder<ParseObject> query2;
    query2 = await getQueryAll(query, pagination);
    ParseResponse? parseResponse;
    try {
      parseResponse = await query2.query();
      List<ExpertiseModel> listTemp = <ExpertiseModel>[];
      if (parseResponse.success && parseResponse.results != null) {
        for (var element in parseResponse.results!) {
          listTemp.add(ExpertiseEntity().toModel(element));
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
        where: 'ExpertiseRepositoryB4a.list',
        originalError:
            '${parseResponse.error!.code} -${parseResponse.error!.message}',
      );
    }
  }

  // Future<String> update(ExpertiseModel model) async {
  //   final parseObject = await ExpertiseEntity().toParse(model);
  //   ParseResponse? parseResponse;
  //   try {
  //     parseResponse = await parseObject.save();

  //     if (parseResponse.success && parseResponse.results != null) {
  //       ParseObject parseObjectItem =
  //           parseResponse.results!.first as ParseObject;
  //       return parseObjectItem.objectId!;
  //     } else {
  //       throw Exception();
  //     }
  //   } on Exception {
  //     var errorTranslated =
  //         ParseErrorTranslate.translate(parseResponse!.error!);
  //     throw B4aException(
  //       errorTranslated,
  //       where: 'ExpertiseRepositoryB4a.update',
  //       originalError:
  //           '${parseResponse.error!.code} -${parseResponse.error!.message}',
  //     );
  //   }
  // }

  // Future<bool> delete(String modelId) async {
  //   final parseObject = ParseObject(ExpertiseEntity.className);
  //   parseObject.objectId = modelId;
  //   parseObject.set(ExpertiseEntity.isDeleted, true);
  //   ParseResponse? parseResponse;

  //   try {
  //     parseResponse = await parseObject.save();
  //     if (parseResponse.success && parseResponse.results != null) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } on Exception {
  //     var errorTranslated =
  //         ParseErrorTranslate.translate(parseResponse!.error!);
  //     throw B4aException(
  //       errorTranslated,
  //       where: 'ExpertiseRepositoryB4a.update',
  //       originalError:
  //           '${parseResponse.error!.code} -${parseResponse.error!.message}',
  //     );
  //   }
  // }
}
