import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/clinic_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/clinic_repository.dart';
import '../../../../data/b4a/entity/clinic_entity.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'clinic_search_event.dart';
import 'clinic_search_state.dart';

class ClinicSearchBloc extends Bloc<ClinicSearchEvent, ClinicSearchState> {
  final ClinicRepository _clinicRepository;
  ClinicSearchBloc(
      {required ClinicRepository clinicRepository,
      required UserProfileModel seller})
      : _clinicRepository = clinicRepository,
        super(ClinicSearchState.initial(seller: seller)) {
    on<ClinicSearchEventFormSubmitted>(_onClinicSearchEventFormSubmitted);
    on<ClinicSearchEventPreviousPage>(_onClinicSearchEventPreviousPage);
    on<ClinicSearchEventNextPage>(_onUserProfileSearchEventNextPage);
    on<ClinicSearchEventUpdateList>(_onClinicSearchEventUpdateList);
    on<ClinicSearchEventRemoveFromList>(_onClinicSearchEventRemoveFromList);
  }

  FutureOr<void> _onClinicSearchEventFormSubmitted(
      ClinicSearchEventFormSubmitted event,
      Emitter<ClinicSearchState> emit) async {
    emit(state.copyWith(
      status: ClinicSearchStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(ClinicEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(ClinicEntity.className));

      if (event.nameContainsBool) {
        query.whereContains(ClinicEntity.name, event.nameContainsString);
      }
      if (event.phoneEqualsToBool) {
        query.whereEqualTo(ClinicEntity.phone, event.phoneEqualsToString);
      }
      query.whereEqualTo(
          ClinicEntity.seller,
          (ParseObject(UserProfileEntity.className)..objectId = state.seller.id)
              .toPointer());
      query.orderByDescending(ClinicEntity.name);
      List<ClinicModel> clinicModelListGet = await _clinicRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: ClinicSearchStateStatus.success,
        list: clinicModelListGet,
        query: query,
      ));
    } catch (e) {
      print(e);
      emit(
        state.copyWith(
            status: ClinicSearchStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onClinicSearchEventPreviousPage(
      ClinicSearchEventPreviousPage event,
      Emitter<ClinicSearchState> emit) async {
    emit(
      state.copyWith(
        status: ClinicSearchStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<ClinicModel> clinicModelListGet = await _clinicRepository.list(
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
        status: ClinicSearchStateStatus.success,
        list: clinicModelListGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: ClinicSearchStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileSearchEventNextPage(
      ClinicSearchEventNextPage event, Emitter<ClinicSearchState> emit) async {
    emit(
      state.copyWith(status: ClinicSearchStateStatus.loading),
    );
    List<ClinicModel> clinicModelListGet = await _clinicRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (clinicModelListGet.isEmpty) {
      emit(state.copyWith(
        status: ClinicSearchStateStatus.success,
        // firstPage: false,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: ClinicSearchStateStatus.success,
        list: clinicModelListGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onClinicSearchEventUpdateList(
      ClinicSearchEventUpdateList event, Emitter<ClinicSearchState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<ClinicModel> clinicModelListTemp = [...state.list];
      clinicModelListTemp.replaceRange(index, index + 1, [event.model]);
      emit(state.copyWith(list: clinicModelListTemp));
    }
  }

  FutureOr<void> _onClinicSearchEventRemoveFromList(
      ClinicSearchEventRemoveFromList event, Emitter<ClinicSearchState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.modelId);
    if (index >= 0) {
      List<ClinicModel> clinicModelListTemp = [...state.list];
      clinicModelListTemp.removeAt(index);
      emit(state.copyWith(list: clinicModelListTemp));
    }
  }
}
