import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'package:agendarep/app/core/models/user_profile_model.dart';

import '../../../../core/models/cycle_model.dart';
import '../../../../data/b4a/entity/cycle_entity.dart';

enum CycleListStateStatus { initial, loading, success, error }

class CycleListState {
  final CycleListStateStatus status;
  final String? error;
  final List<CycleModel> cycleModelList;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;
  final UserProfileModel seller;
  final bool isArchived;

  CycleListState({
    required this.status,
    this.error,
    required this.cycleModelList,
    required this.page,
    required this.limit,
    required this.firstPage,
    required this.lastPage,
    required this.query,
    required this.seller,
    required this.isArchived,
  });
  CycleListState.initial({required this.seller})
      : status = CycleListStateStatus.initial,
        error = '',
        cycleModelList = [],
        page = 1,
        limit = 2,
        firstPage = true,
        lastPage = false,
        query = QueryBuilder<ParseObject>(ParseObject(CycleEntity.className)),
        isArchived = false;

  CycleListState copyWith({
    CycleListStateStatus? status,
    String? error,
    List<CycleModel>? cycleModelList,
    int? page,
    int? limit,
    bool? firstPage,
    bool? lastPage,
    QueryBuilder<ParseObject>? query,
    UserProfileModel? seller,
    bool? isArchived,
  }) {
    return CycleListState(
      status: status ?? this.status,
      error: error ?? this.error,
      cycleModelList: cycleModelList ?? this.cycleModelList,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      firstPage: firstPage ?? this.firstPage,
      lastPage: lastPage ?? this.lastPage,
      query: query ?? this.query,
      seller: seller ?? this.seller,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CycleListState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.cycleModelList, cycleModelList) &&
        other.page == page &&
        other.limit == limit &&
        other.firstPage == firstPage &&
        other.lastPage == lastPage &&
        other.query == query &&
        other.seller == seller &&
        other.isArchived == isArchived;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        cycleModelList.hashCode ^
        page.hashCode ^
        limit.hashCode ^
        firstPage.hashCode ^
        lastPage.hashCode ^
        query.hashCode ^
        seller.hashCode ^
        isArchived.hashCode;
  }

  @override
  String toString() {
    return 'CycleListState(status: $status, error: $error, cycleModelList: $cycleModelList, page: $page, limit: $limit, firstPage: $firstPage, lastPage: $lastPage, query: $query, seller: $seller)';
  }
}
