import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/cycle_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/cycle_repository.dart';
import '../../../../data/b4a/entity/cycle_entity.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'cycle_list_event.dart';
import 'cycle_list_state.dart';

class CycleListBloc extends Bloc<CycleListEvent, CycleListState> {
  final CycleRepository _cycleRepository;
  CycleListBloc(
      {required CycleRepository cycleRepository,
      required UserProfileModel seller})
      : _cycleRepository = cycleRepository,
        super(CycleListState.initial(seller: seller)) {
    on<CycleListEventIsArchived>(_onCycleListEventIsArchived);
    on<CycleListEventPreviousPage>(_onCycleListEventPreviousPage);
    on<CycleListEventNextPage>(_onUserProfileListEventNextPage);
    on<CycleListEventUpdateList>(_onCycleListEventUpdateList);
    on<CycleListEventRemoveFromList>(_onCycleListEventRemoveFromList);
    add(CycleListEventIsArchived());
  }

  FutureOr<void> _onCycleListEventIsArchived(
      CycleListEventIsArchived event, Emitter<CycleListState> emit) async {
    emit(state.copyWith(
      status: CycleListStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      cycleModelList: [],
      query: QueryBuilder<ParseObject>(ParseObject(CycleEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(CycleEntity.className));

      if (event.isArchived) {
        query.whereEqualTo(CycleEntity.isArchived, event.isArchived);
      }
      query.whereEqualTo(
          CycleEntity.seller,
          (ParseObject(UserProfileEntity.className)..objectId = state.seller.id)
              .toPointer());
      query.orderByDescending('updatedAt');
      List<CycleModel> cycleModelListGet = await _cycleRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: CycleListStateStatus.success,
        cycleModelList: cycleModelListGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: CycleListStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onCycleListEventPreviousPage(
      CycleListEventPreviousPage event, Emitter<CycleListState> emit) async {
    emit(
      state.copyWith(
        status: CycleListStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<CycleModel> cycleModelListGet = await _cycleRepository.list(
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
        status: CycleListStateStatus.success,
        cycleModelList: cycleModelListGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: CycleListStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileListEventNextPage(
      CycleListEventNextPage event, Emitter<CycleListState> emit) async {
    emit(
      state.copyWith(status: CycleListStateStatus.loading),
    );
    List<CycleModel> cycleModelListGet = await _cycleRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (cycleModelListGet.isEmpty) {
      emit(state.copyWith(
        status: CycleListStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: CycleListStateStatus.success,
        cycleModelList: cycleModelListGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onCycleListEventUpdateList(
      CycleListEventUpdateList event, Emitter<CycleListState> emit) {
    int index = state.cycleModelList
        .indexWhere((model) => model.id == event.cycleModel.id);
    if (index >= 0) {
      List<CycleModel> cycleModelListTemp = [...state.cycleModelList];
      cycleModelListTemp.replaceRange(index, index + 1, [event.cycleModel]);
      emit(state.copyWith(cycleModelList: cycleModelListTemp));
    }
  }

  FutureOr<void> _onCycleListEventRemoveFromList(
      CycleListEventRemoveFromList event, Emitter<CycleListState> emit) {
    int index =
        state.cycleModelList.indexWhere((model) => model.id == event.modelId);
    if (index >= 0) {
      List<CycleModel> cycleModelListTemp = [...state.cycleModelList];
      cycleModelListTemp.removeAt(index);
      emit(state.copyWith(cycleModelList: cycleModelListTemp));
    }
  }
}
