import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/medical_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/medical_repository.dart';
import '../../../../data/b4a/entity/medical_entity.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'medical_search_event.dart';
import 'medical_search_state.dart';

class MedicalSearchBloc extends Bloc<MedicalSearchEvent, MedicalSearchState> {
  final MedicalRepository _medicalRepository;
  MedicalSearchBloc(
      {required MedicalRepository medicalRepository,
      required UserProfileModel seller})
      : _medicalRepository = medicalRepository,
        super(MedicalSearchState.initial(seller: seller)) {
    on<MedicalSearchEventFormSubmitted>(_onMedicalSearchEventFormSubmitted);
    on<MedicalSearchEventPreviousPage>(_onMedicalSearchEventPreviousPage);
    on<MedicalSearchEventNextPage>(_onUserProfileSearchEventNextPage);
    on<MedicalSearchEventUpdateList>(_onMedicalSearchEventUpdateList);
    on<MedicalSearchEventRemoveFromList>(_onMedicalSearchEventRemoveFromList);
  }

  FutureOr<void> _onMedicalSearchEventFormSubmitted(
      MedicalSearchEventFormSubmitted event,
      Emitter<MedicalSearchState> emit) async {
    emit(state.copyWith(
      status: MedicalSearchStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      medicalModelList: [],
      query: QueryBuilder<ParseObject>(ParseObject(MedicalEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(MedicalEntity.className));

      if (event.emailEqualsToBool) {
        query.whereEqualTo(MedicalEntity.email, event.emailEqualsToString);
      }
      if (event.nameContainsBool) {
        query.whereContains(MedicalEntity.name, event.nameContainsString);
      }
      if (event.phoneEqualsToBool) {
        query.whereEqualTo(MedicalEntity.phone, event.phoneEqualsToString);
      }
      if (event.crmEqualsToBool) {
        query.whereEqualTo(MedicalEntity.crm, event.crmEqualsToString);
      }
      if (event.isBlockedBool) {
        query.whereEqualTo(MedicalEntity.isBlocked, event.isBlockedSelected);
      }
      if (event.birthdayEqualsToBool) {
        query.whereEqualTo(MedicalEntity.birthday, event.birthdayEqualsTo);
      }

      query.whereEqualTo(
          MedicalEntity.seller,
          (ParseObject(UserProfileEntity.className)..objectId = state.seller.id)
              .toPointer());
      query.orderByDescending('updatedAt');

      List<MedicalModel> medicalModelListGet = await _medicalRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
        [MedicalEntity.expertises],
      );

      emit(state.copyWith(
        status: MedicalSearchStateStatus.success,
        medicalModelList: medicalModelListGet,
        query: query,
      ));
    } catch (e) {
      print(e);
      emit(
        state.copyWith(
            status: MedicalSearchStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onMedicalSearchEventPreviousPage(
      MedicalSearchEventPreviousPage event,
      Emitter<MedicalSearchState> emit) async {
    emit(
      state.copyWith(
        status: MedicalSearchStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<MedicalModel> medicalModelListGet = await _medicalRepository.list(
        state.query,
        Pagination(page: state.page, limit: state.limit),
        [MedicalEntity.expertises],
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
        status: MedicalSearchStateStatus.success,
        medicalModelList: medicalModelListGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: MedicalSearchStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileSearchEventNextPage(
      MedicalSearchEventNextPage event,
      Emitter<MedicalSearchState> emit) async {
    emit(
      state.copyWith(status: MedicalSearchStateStatus.loading),
    );
    List<MedicalModel> medicalModelListGet = await _medicalRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
      [MedicalEntity.expertises],
    );
    if (medicalModelListGet.isEmpty) {
      emit(state.copyWith(
        status: MedicalSearchStateStatus.success,
        // firstPage: false,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: MedicalSearchStateStatus.success,
        medicalModelList: medicalModelListGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onMedicalSearchEventUpdateList(
      MedicalSearchEventUpdateList event, Emitter<MedicalSearchState> emit) {
    int index = state.medicalModelList
        .indexWhere((model) => model.id == event.medicalModel.id);
    if (index >= 0) {
      List<MedicalModel> medicalModelListTemp = [...state.medicalModelList];
      medicalModelListTemp.replaceRange(index, index + 1, [event.medicalModel]);
      emit(state.copyWith(medicalModelList: medicalModelListTemp));
    }
  }

  FutureOr<void> _onMedicalSearchEventRemoveFromList(
      MedicalSearchEventRemoveFromList event,
      Emitter<MedicalSearchState> emit) {
    int index =
        state.medicalModelList.indexWhere((model) => model.id == event.modelId);
    if (index >= 0) {
      List<MedicalModel> medicalModelListTemp = [...state.medicalModelList];
      medicalModelListTemp.removeAt(index);
      emit(state.copyWith(medicalModelList: medicalModelListTemp));
    }
  }
}
