import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/clinic_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/clinic_repository.dart';
import '../../../../data/b4a/entity/clinic_entity.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'clinic_select_event.dart';
import 'clinic_select_state.dart';

class ClinicSelectBloc extends Bloc<ClinicSelectEvent, ClinicSelectState> {
  final ClinicRepository _clinicRepository;
  ClinicSelectBloc(
      {required ClinicRepository clinicRepository,
      required UserProfileModel seller})
      : _clinicRepository = clinicRepository,
        super(ClinicSelectState.initial(seller: seller)) {
    on<ClinicSelectEventStartQuery>(_onClinicSelectEventStartQuery);
    on<ClinicSelectEventPreviousPage>(_onClinicSelectEventPreviousPage);
    on<ClinicSelectEventNextPage>(_onClinicSelectEventNextPage);
    on<ClinicSelectEventFormSubmitted>(_onClinicSelectEventFormSubmitted);
    add(ClinicSelectEventStartQuery());
  }

  FutureOr<void> _onClinicSelectEventStartQuery(
      ClinicSelectEventStartQuery event,
      Emitter<ClinicSelectState> emit) async {
    emit(state.copyWith(
      status: ClinicSelectStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(ClinicEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(ClinicEntity.className));
      query.keysToReturn(['name']);

      query.whereEqualTo(
          ClinicEntity.seller,
          (ParseObject(UserProfileEntity.className)..objectId = state.seller.id)
              .toPointer());
      query.orderByDescending('updatedAt');
      List<ClinicModel> listGet = await _clinicRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: ClinicSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: ClinicSelectStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onClinicSelectEventPreviousPage(
      ClinicSelectEventPreviousPage event,
      Emitter<ClinicSelectState> emit) async {
    emit(
      state.copyWith(
        status: ClinicSelectStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<ClinicModel> listGet = await _clinicRepository.list(
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
        status: ClinicSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: ClinicSelectStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onClinicSelectEventNextPage(
      ClinicSelectEventNextPage event, Emitter<ClinicSelectState> emit) async {
    emit(
      state.copyWith(status: ClinicSelectStateStatus.loading),
    );
    List<ClinicModel> listGet = await _clinicRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: ClinicSelectStateStatus.success,
        // firstPage: false,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: ClinicSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onClinicSelectEventFormSubmitted(
      ClinicSelectEventFormSubmitted event, Emitter<ClinicSelectState> emit) {
    if (event.name.isEmpty) {
      emit(state.copyWith(listFiltered: state.list));
    } else {
      List<ClinicModel> listTemp;
      listTemp = state.list.where((e) => e.name!.contains(event.name)).toList();
      emit(state.copyWith(listFiltered: listTemp));
    }
  }
}
