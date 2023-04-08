import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'package:agendarep/app/core/models/user_profile_model.dart';

import '../../../../core/models/medical_model.dart';
import '../../../../data/b4a/entity/medical_entity.dart';

enum MedicalSelectStateStatus { initial, loading, success, error }

class MedicalSelectState {
  final MedicalSelectStateStatus status;
  final String? error;
  final List<MedicalModel> list;
  final List<MedicalModel> listFiltered;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;
  final UserProfileModel seller;

  MedicalSelectState({
    required this.status,
    this.error,
    required this.list,
    required this.listFiltered,
    required this.page,
    required this.limit,
    required this.firstPage,
    required this.lastPage,
    required this.query,
    required this.seller,
  });
  MedicalSelectState.initial({required this.seller})
      : status = MedicalSelectStateStatus.initial,
        error = '',
        list = [],
        listFiltered = [],
        page = 1,
        limit = 2,
        firstPage = true,
        lastPage = false,
        query = QueryBuilder<ParseObject>(ParseObject(MedicalEntity.className));

  MedicalSelectState copyWith({
    MedicalSelectStateStatus? status,
    String? error,
    List<MedicalModel>? list,
    List<MedicalModel>? listFiltered,
    int? page,
    int? limit,
    bool? firstPage,
    bool? lastPage,
    QueryBuilder<ParseObject>? query,
    UserProfileModel? seller,
  }) {
    return MedicalSelectState(
      status: status ?? this.status,
      error: error ?? this.error,
      list: list ?? this.list,
      listFiltered: listFiltered ?? this.listFiltered,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      firstPage: firstPage ?? this.firstPage,
      lastPage: lastPage ?? this.lastPage,
      query: query ?? this.query,
      seller: seller ?? this.seller,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MedicalSelectState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.list, list) &&
        listEquals(other.listFiltered, listFiltered) &&
        other.page == page &&
        other.limit == limit &&
        other.firstPage == firstPage &&
        other.lastPage == lastPage &&
        other.query == query &&
        other.seller == seller;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        list.hashCode ^
        listFiltered.hashCode ^
        page.hashCode ^
        limit.hashCode ^
        firstPage.hashCode ^
        lastPage.hashCode ^
        query.hashCode ^
        seller.hashCode;
  }

  @override
  String toString() {
    return 'MedicalSelectState(status: $status, error: $error, list: $list, page: $page, limit: $limit, firstPage: $firstPage, lastPage: $lastPage, query: $query, seller: $seller)';
  }
}
