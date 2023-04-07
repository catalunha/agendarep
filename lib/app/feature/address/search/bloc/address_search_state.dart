import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'package:agendarep/app/core/models/user_profile_model.dart';

import '../../../../core/models/address_model.dart';
import '../../../../data/b4a/entity/address_entity.dart';

enum AddressSearchStateStatus { initial, loading, success, error }

class AddressSearchState {
  final AddressSearchStateStatus status;
  final String? error;
  final List<AddressModel> list;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;
  final UserProfileModel seller;

  AddressSearchState({
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
  AddressSearchState.initial({required this.seller})
      : status = AddressSearchStateStatus.initial,
        error = '',
        list = [],
        page = 1,
        limit = 2,
        firstPage = true,
        lastPage = false,
        query = QueryBuilder<ParseObject>(ParseObject(AddressEntity.className));

  AddressSearchState copyWith({
    AddressSearchStateStatus? status,
    String? error,
    List<AddressModel>? list,
    int? page,
    int? limit,
    bool? firstPage,
    bool? lastPage,
    QueryBuilder<ParseObject>? query,
    UserProfileModel? seller,
  }) {
    return AddressSearchState(
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

    return other is AddressSearchState &&
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
    return 'AddressSearchState(status: $status, error: $error, list: $list, page: $page, limit: $limit, firstPage: $firstPage, lastPage: $lastPage, query: $query, seller: $seller)';
  }
}
