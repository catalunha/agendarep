import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/medical_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/medical_repository.dart';
import '../../../../data/b4a/entity/medical_entity.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'medical_select_event.dart';
import 'medical_select_state.dart';

class MedicalSelectBloc extends Bloc<MedicalSelectEvent, MedicalSelectState> {
  final MedicalRepository _medicalRepository;
  MedicalSelectBloc(
      {required MedicalRepository medicalRepository,
      required UserProfileModel seller})
      : _medicalRepository = medicalRepository,
        super(MedicalSelectState.initial(seller: seller)) {
    on<MedicalSelectEventStartQuery>(_onMedicalSelectEventStartQuery);
    on<MedicalSelectEventPreviousPage>(_onMedicalSelectEventPreviousPage);
    on<MedicalSelectEventNextPage>(_onMedicalSelectEventNextPage);
    on<MedicalSelectEventFormSubmitted>(_onMedicalSelectEventFormSubmitted);
    add(MedicalSelectEventStartQuery());
  }

  FutureOr<void> _onMedicalSelectEventStartQuery(
      MedicalSelectEventStartQuery event,
      Emitter<MedicalSelectState> emit) async {
    emit(state.copyWith(
      status: MedicalSelectStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(MedicalEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(MedicalEntity.className));
      query.whereEqualTo(MedicalEntity.isDeleted, false);
      // query.includeObject(['seller']);
      query.keysToReturn(['name']);

      query.whereEqualTo(
          MedicalEntity.seller,
          (ParseObject(UserProfileEntity.className)..objectId = state.seller.id)
              .toPointer());
      query.orderByDescending('updatedAt');
      List<MedicalModel> listGet = await _medicalRepository.list(
          query,
          Pagination(page: state.page, limit: state.limit),
          [MedicalEntity.expertises]);

      emit(state.copyWith(
        status: MedicalSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: MedicalSelectStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onMedicalSelectEventPreviousPage(
      MedicalSelectEventPreviousPage event,
      Emitter<MedicalSelectState> emit) async {
    emit(
      state.copyWith(
        status: MedicalSelectStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<MedicalModel> listGet = await _medicalRepository.list(
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
        status: MedicalSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: MedicalSelectStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onMedicalSelectEventNextPage(MedicalSelectEventNextPage event,
      Emitter<MedicalSelectState> emit) async {
    emit(
      state.copyWith(status: MedicalSelectStateStatus.loading),
    );
    List<MedicalModel> listGet = await _medicalRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: MedicalSelectStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: MedicalSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onMedicalSelectEventFormSubmitted(
      MedicalSelectEventFormSubmitted event, Emitter<MedicalSelectState> emit) {
    if (event.name.isEmpty) {
      emit(state.copyWith(listFiltered: state.list));
    } else {
      List<MedicalModel> listTemp;
      listTemp = state.list.where((e) => e.name!.contains(event.name)).toList();
      emit(state.copyWith(listFiltered: listTemp));
    }
  }
}
