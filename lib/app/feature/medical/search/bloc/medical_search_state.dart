import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'package:agendarep/app/core/models/user_profile_model.dart';

import '../../../../core/models/medical_model.dart';
import '../../../../data/b4a/entity/medical_entity.dart';

enum MedicalSearchStateStatus { initial, loading, success, error }

class MedicalSearchState {
  final MedicalSearchStateStatus status;
  final String? error;
  final List<MedicalModel> medicalModelList;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;
  final UserProfileModel seller;

  MedicalSearchState({
    required this.status,
    this.error,
    required this.medicalModelList,
    required this.page,
    required this.limit,
    required this.firstPage,
    required this.lastPage,
    required this.query,
    required this.seller,
  });
  MedicalSearchState.initial({required this.seller})
      : status = MedicalSearchStateStatus.initial,
        error = '',
        medicalModelList = [],
        page = 1,
        limit = 500,
        firstPage = true,
        lastPage = false,
        query = QueryBuilder<ParseObject>(ParseObject(MedicalEntity.className));

  MedicalSearchState copyWith({
    MedicalSearchStateStatus? status,
    String? error,
    List<MedicalModel>? medicalModelList,
    int? page,
    int? limit,
    bool? firstPage,
    bool? lastPage,
    QueryBuilder<ParseObject>? query,
    UserProfileModel? seller,
  }) {
    return MedicalSearchState(
      status: status ?? this.status,
      error: error ?? this.error,
      medicalModelList: medicalModelList ?? this.medicalModelList,
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

    return other is MedicalSearchState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.medicalModelList, medicalModelList) &&
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
        medicalModelList.hashCode ^
        page.hashCode ^
        limit.hashCode ^
        firstPage.hashCode ^
        lastPage.hashCode ^
        query.hashCode ^
        seller.hashCode;
  }

  @override
  String toString() {
    return 'MedicalSearchState(status: $status, error: $error, medicalModelList: $medicalModelList, page: $page, limit: $limit, firstPage: $firstPage, lastPage: $lastPage, query: $query, seller: $seller)';
  }
}
