import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'package:agendarep/app/core/models/user_profile_model.dart';

import '../../../../core/models/region_model.dart';
import '../../../../data/b4a/entity/region_entity.dart';

enum RegionSearchStateStatus { initial, loading, success, error }

class RegionSearchState {
  final RegionSearchStateStatus status;
  final String? error;
  final List<RegionModel> list;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;
  final UserProfileModel seller;

  RegionSearchState({
    required this.status,
    this.error,
    required this.list,
    required this.page,
    required this.limit,
    required this.firstPage,
    required this.lastPage,
    required this.query,
    required this.seller,
  });
  RegionSearchState.initial({required this.seller})
      : status = RegionSearchStateStatus.initial,
        error = '',
        list = [],
        page = 1,
        limit = 500,
        firstPage = true,
        lastPage = false,
        query = QueryBuilder<ParseObject>(ParseObject(RegionEntity.className));

  RegionSearchState copyWith({
    RegionSearchStateStatus? status,
    String? error,
    List<RegionModel>? list,
    int? page,
    int? limit,
    bool? firstPage,
    bool? lastPage,
    QueryBuilder<ParseObject>? query,
    UserProfileModel? seller,
  }) {
    return RegionSearchState(
      status: status ?? this.status,
      error: error ?? this.error,
      list: list ?? this.list,
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

    return other is RegionSearchState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.list, list) &&
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
        page.hashCode ^
        limit.hashCode ^
        firstPage.hashCode ^
        lastPage.hashCode ^
        query.hashCode ^
        seller.hashCode;
  }

  @override
  String toString() {
    return 'RegionSearchState(status: $status, error: $error, list: $list, page: $page, limit: $limit, firstPage: $firstPage, lastPage: $lastPage, query: $query, seller: $seller)';
  }
}
