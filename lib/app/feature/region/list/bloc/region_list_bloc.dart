import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/region_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/region_repository.dart';
import '../../../../data/b4a/entity/region_entity.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'region_list_event.dart';
import 'region_list_state.dart';

class RegionListBloc extends Bloc<RegionListEvent, RegionListState> {
  final RegionRepository _regionRepository;
  RegionListBloc(
      {required RegionRepository regionRepository,
      required UserProfileModel seller})
      : _regionRepository = regionRepository,
        super(RegionListState.initial(seller: seller)) {
    on<RegionListEventList>(_onRegionListEventList);
    on<RegionListEventPreviousPage>(_onRegionListEventPreviousPage);
    on<RegionListEventNextPage>(_onUserProfileListEventNextPage);
    on<RegionListEventUpdateList>(_onRegionListEventUpdateList);
    on<RegionListEventRemoveFromList>(_onRegionListEventRemoveFromList);
    add(RegionListEventList());
  }

  FutureOr<void> _onRegionListEventList(
      RegionListEventList event, Emitter<RegionListState> emit) async {
    emit(state.copyWith(
      status: RegionListStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(RegionEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(RegionEntity.className));

      query.whereEqualTo(
          RegionEntity.seller,
          (ParseObject(UserProfileEntity.className)..objectId = state.seller.id)
              .toPointer());
      query.orderByDescending('updatedAt');
      List<RegionModel> regionModelListGet = await _regionRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: RegionListStateStatus.success,
        list: regionModelListGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: RegionListStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onRegionListEventPreviousPage(
      RegionListEventPreviousPage event, Emitter<RegionListState> emit) async {
    emit(
      state.copyWith(
        status: RegionListStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<RegionModel> regionModelListGet = await _regionRepository.list(
        state.query,
        Pagination(page: state.page, limit: state.limit),
      );
      if (state.page == 1) {
        emit(
          state.copyWith(
            page: 1,
            firstPage: true,
            lastPage: false,
          ),
        );
      }
      emit(state.copyWith(
        status: RegionListStateStatus.success,
        list: regionModelListGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: RegionListStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileListEventNextPage(
      RegionListEventNextPage event, Emitter<RegionListState> emit) async {
    emit(
      state.copyWith(status: RegionListStateStatus.loading),
    );
    List<RegionModel> regionModelListGet = await _regionRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (regionModelListGet.isEmpty) {
      emit(state.copyWith(
        status: RegionListStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: RegionListStateStatus.success,
        list: regionModelListGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onRegionListEventUpdateList(
      RegionListEventUpdateList event, Emitter<RegionListState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<RegionModel> regionModelListTemp = [...state.list];
      regionModelListTemp.replaceRange(index, index + 1, [event.model]);
      emit(state.copyWith(list: regionModelListTemp));
    }
  }

  FutureOr<void> _onRegionListEventRemoveFromList(
      RegionListEventRemoveFromList event, Emitter<RegionListState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.modelId);
    if (index >= 0) {
      List<RegionModel> regionModelListTemp = [...state.list];
      regionModelListTemp.removeAt(index);
      emit(state.copyWith(list: regionModelListTemp));
    }
  }
}
