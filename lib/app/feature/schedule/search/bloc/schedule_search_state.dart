import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'package:agendarep/app/core/models/user_profile_model.dart';

import '../../../../core/models/schedule_models.dart';
import '../../../../data/b4a/entity/schedule_entity.dart';

enum ScheduleSearchStateStatus { initial, loading, success, error }

class ScheduleSearchState {
  final ScheduleSearchStateStatus status;
  final String? error;
  final List<ScheduleModel> list;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;
  final UserProfileModel seller;

  ScheduleSearchState({
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
  ScheduleSearchState.initial({required this.seller})
      : status = ScheduleSearchStateStatus.initial,
        error = '',
        list = [],
        page = 1,
        limit = 2,
        firstPage = true,
        lastPage = false,
        query =
            QueryBuilder<ParseObject>(ParseObject(ScheduleEntity.className));

  ScheduleSearchState copyWith({
    ScheduleSearchStateStatus? status,
    String? error,
    List<ScheduleModel>? list,
    int? page,
    int? limit,
    bool? firstPage,
    bool? lastPage,
    QueryBuilder<ParseObject>? query,
    UserProfileModel? seller,
  }) {
    return ScheduleSearchState(
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

    return other is ScheduleSearchState &&
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
    return 'ScheduleSearchState(status: $status, error: $error, list: $list, page: $page, limit: $limit, firstPage: $firstPage, lastPage: $lastPage, query: $query, seller: $seller)';
  }
}
