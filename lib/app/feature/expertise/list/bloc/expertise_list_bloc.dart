import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/expertise_model.dart';
import '../../../../core/repositories/expertise_repository.dart';
import '../../../../data/b4a/entity/expertise_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'expertise_list_event.dart';
import 'expertise_list_state.dart';

class ExpertiseListBloc extends Bloc<ExpertiseListEvent, ExpertiseListState> {
  final ExpertiseRepository eExpertiseRepository;
  ExpertiseListBloc({
    required ExpertiseRepository expertiseRepository,
  })  : eExpertiseRepository = expertiseRepository,
        super(ExpertiseListState.initial()) {
    on<ExpertiseListEventList>(_onExpertiseListEventList);
    on<ExpertiseListEventPreviousPage>(_onExpertiseListEventPreviousPage);
    on<ExpertiseListEventNextPage>(_onUserProfileListEventNextPage);
    add(ExpertiseListEventList());
  }

  FutureOr<void> _onExpertiseListEventList(
      ExpertiseListEventList event, Emitter<ExpertiseListState> emit) async {
    emit(state.copyWith(
      status: ExpertiseListStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(ExpertiseEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(ExpertiseEntity.className));

      query.orderByAscending('name');
      List<ExpertiseModel> expertiseModelListGet =
          await eExpertiseRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: ExpertiseListStateStatus.success,
        list: expertiseModelListGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: ExpertiseListStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onExpertiseListEventPreviousPage(
      ExpertiseListEventPreviousPage event,
      Emitter<ExpertiseListState> emit) async {
    emit(
      state.copyWith(
        status: ExpertiseListStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<ExpertiseModel> expertiseModelListGet =
          await eExpertiseRepository.list(
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
        status: ExpertiseListStateStatus.success,
        list: expertiseModelListGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: ExpertiseListStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileListEventNextPage(
      ExpertiseListEventNextPage event,
      Emitter<ExpertiseListState> emit) async {
    emit(
      state.copyWith(status: ExpertiseListStateStatus.loading),
    );
    List<ExpertiseModel> expertiseModelListGet =
        await eExpertiseRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (expertiseModelListGet.isEmpty) {
      emit(state.copyWith(
        status: ExpertiseListStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: ExpertiseListStateStatus.success,
        list: expertiseModelListGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }
}
