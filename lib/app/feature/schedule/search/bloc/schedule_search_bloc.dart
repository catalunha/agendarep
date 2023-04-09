import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/schedule_models.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/schedule_repository.dart';
import '../../../../data/b4a/entity/schedule_entity.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'schedule_search_event.dart';
import 'schedule_search_state.dart';

class ScheduleSearchBloc
    extends Bloc<ScheduleSearchEvent, ScheduleSearchState> {
  final ScheduleRepository _scheduleRepository;
  ScheduleSearchBloc(
      {required ScheduleRepository scheduleRepository,
      required UserProfileModel seller})
      : _scheduleRepository = scheduleRepository,
        super(ScheduleSearchState.initial(seller: seller)) {
    on<ScheduleSearchEventFormSubmitted>(_onScheduleSearchEventFormSubmitted);
    on<ScheduleSearchEventPreviousPage>(_onScheduleSearchEventPreviousPage);
    on<ScheduleSearchEventNextPage>(_onUserProfileSearchEventNextPage);
    on<ScheduleSearchEventUpdateList>(_onScheduleSearchEventUpdateList);
    on<ScheduleSearchEventRemoveFromList>(_onScheduleSearchEventRemoveFromList);
  }

  FutureOr<void> _onScheduleSearchEventFormSubmitted(
      ScheduleSearchEventFormSubmitted event,
      Emitter<ScheduleSearchState> emit) async {
    emit(state.copyWith(
      status: ScheduleSearchStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(ScheduleEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(ScheduleEntity.className));

      query.whereEqualTo(
          ScheduleEntity.seller,
          (ParseObject(UserProfileEntity.className)..objectId = state.seller.id)
              .toPointer());
      query.orderByDescending('updatedAt');

      List<ScheduleModel> listGet = await _scheduleRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );
      print('>>>>>>$listGet');
      emit(state.copyWith(
        status: ScheduleSearchStateStatus.success,
        list: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: ScheduleSearchStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onScheduleSearchEventPreviousPage(
      ScheduleSearchEventPreviousPage event,
      Emitter<ScheduleSearchState> emit) async {
    emit(
      state.copyWith(
        status: ScheduleSearchStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<ScheduleModel> listGet = await _scheduleRepository.list(
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
        status: ScheduleSearchStateStatus.success,
        list: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: ScheduleSearchStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileSearchEventNextPage(
      ScheduleSearchEventNextPage event,
      Emitter<ScheduleSearchState> emit) async {
    emit(
      state.copyWith(status: ScheduleSearchStateStatus.loading),
    );
    List<ScheduleModel> listGet = await _scheduleRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: ScheduleSearchStateStatus.success,
        // firstPage: false,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: ScheduleSearchStateStatus.success,
        list: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onScheduleSearchEventUpdateList(
      ScheduleSearchEventUpdateList event, Emitter<ScheduleSearchState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<ScheduleModel> listTemp = [...state.list];
      listTemp.replaceRange(index, index + 1, [event.model]);
      emit(state.copyWith(list: listTemp));
    }
  }

  FutureOr<void> _onScheduleSearchEventRemoveFromList(
      ScheduleSearchEventRemoveFromList event,
      Emitter<ScheduleSearchState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.modelId);
    if (index >= 0) {
      List<ScheduleModel> listTemp = [...state.list];
      listTemp.removeAt(index);
      emit(state.copyWith(list: listTemp));
    }
  }
}
