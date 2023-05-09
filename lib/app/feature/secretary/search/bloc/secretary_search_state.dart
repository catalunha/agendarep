import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'package:agendarep/app/core/models/user_profile_model.dart';

import '../../../../core/models/secretary_model.dart';
import '../../../../data/b4a/entity/secretary_entity.dart';

enum SecretarySearchStateStatus { initial, loading, success, error }

class SecretarySearchState {
  final SecretarySearchStateStatus status;
  final String? error;
  final List<SecretaryModel> secretaryModelList;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;
  final UserProfileModel seller;

  SecretarySearchState({
    required this.status,
    this.error,
    required this.secretaryModelList,
    required this.page,
    required this.limit,
    required this.firstPage,
    required this.lastPage,
    required this.query,
    required this.seller,
  });
  SecretarySearchState.initial({required this.seller})
      : status = SecretarySearchStateStatus.initial,
        error = '',
        secretaryModelList = [],
        page = 1,
        limit = 500,
        firstPage = true,
        lastPage = false,
        query =
            QueryBuilder<ParseObject>(ParseObject(SecretaryEntity.className));

  SecretarySearchState copyWith({
    SecretarySearchStateStatus? status,
    String? error,
    List<SecretaryModel>? secretaryModelList,
    int? page,
    int? limit,
    bool? firstPage,
    bool? lastPage,
    QueryBuilder<ParseObject>? query,
    UserProfileModel? seller,
  }) {
    return SecretarySearchState(
      status: status ?? this.status,
      error: error ?? this.error,
      secretaryModelList: secretaryModelList ?? this.secretaryModelList,
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

    return other is SecretarySearchState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.secretaryModelList, secretaryModelList) &&
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
        secretaryModelList.hashCode ^
        page.hashCode ^
        limit.hashCode ^
        firstPage.hashCode ^
        lastPage.hashCode ^
        query.hashCode ^
        seller.hashCode;
  }

  @override
  String toString() {
    return 'SecretarySearchState(status: $status, error: $error, secretaryModelList: $secretaryModelList, page: $page, limit: $limit, firstPage: $firstPage, lastPage: $lastPage, query: $query, seller: $seller)';
  }
}
