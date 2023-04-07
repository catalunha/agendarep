import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/expertise_model.dart';
import '../../../../data/b4a/entity/expertise_entity.dart';

enum ExpertiseListStateStatus { initial, loading, success, error }

class ExpertiseListState {
  final ExpertiseListStateStatus status;
  final String? error;
  final List<ExpertiseModel> list;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;
  final bool isArchived;

  ExpertiseListState({
    required this.status,
    this.error,
    required this.list,
    required this.page,
    required this.limit,
    required this.firstPage,
    required this.lastPage,
    required this.query,
    required this.isArchived,
  });
  ExpertiseListState.initial()
      : status = ExpertiseListStateStatus.initial,
        error = '',
        list = [],
        page = 1,
        limit = 2,
        firstPage = true,
        lastPage = false,
        query =
            QueryBuilder<ParseObject>(ParseObject(ExpertiseEntity.className)),
        isArchived = false;

  ExpertiseListState copyWith({
    ExpertiseListStateStatus? status,
    String? error,
    List<ExpertiseModel>? list,
    int? page,
    int? limit,
    bool? firstPage,
    bool? lastPage,
    QueryBuilder<ParseObject>? query,
    bool? isArchived,
  }) {
    return ExpertiseListState(
      status: status ?? this.status,
      error: error ?? this.error,
      list: list ?? this.list,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      firstPage: firstPage ?? this.firstPage,
      lastPage: lastPage ?? this.lastPage,
      query: query ?? this.query,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpertiseListState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.list, list) &&
        other.page == page &&
        other.limit == limit &&
        other.firstPage == firstPage &&
        other.lastPage == lastPage &&
        other.query == query &&
        other.isArchived == isArchived;
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
        isArchived.hashCode;
  }

  @override
  String toString() {
    return 'ExpertiseListState(status: $status, error: $error, list: $list, page: $page, limit: $limit, firstPage: $firstPage, lastPage: $lastPage, query: $query)';
  }
}
