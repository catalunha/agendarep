import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/secretary_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/secretary_repository.dart';
import '../../../../data/b4a/entity/secretary_entity.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'secretary_search_event.dart';
import 'secretary_search_state.dart';

class SecretarySearchBloc
    extends Bloc<SecretarySearchEvent, SecretarySearchState> {
  final SecretaryRepository _secretaryRepository;
  SecretarySearchBloc(
      {required SecretaryRepository secretaryRepository,
      required UserProfileModel seller})
      : _secretaryRepository = secretaryRepository,
        super(SecretarySearchState.initial(seller: seller)) {
    on<SecretarySearchEventFormSubmitted>(_onSecretarySearchEventFormSubmitted);
    on<SecretarySearchEventPreviousPage>(_onSecretarySearchEventPreviousPage);
    on<SecretarySearchEventNextPage>(_onUserProfileSearchEventNextPage);
    on<SecretarySearchEventUpdateList>(_onSecretarySearchEventUpdateList);
  }

  FutureOr<void> _onSecretarySearchEventFormSubmitted(
      SecretarySearchEventFormSubmitted event,
      Emitter<SecretarySearchState> emit) async {
    emit(state.copyWith(
      status: SecretarySearchStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      secretaryModelList: [],
      query: QueryBuilder<ParseObject>(ParseObject(SecretaryEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(SecretaryEntity.className));

      if (event.emailEqualsToBool) {
        query.whereEqualTo(SecretaryEntity.email, event.emailEqualsToString);
      }
      if (event.nameContainsBool) {
        query.whereContains(SecretaryEntity.name, event.nameContainsString);
      }
      if (event.phoneEqualsToBool) {
        query.whereEqualTo(SecretaryEntity.phone, event.phoneEqualsToString);
      }
      if (event.cpfEqualsToBool) {
        query.whereEqualTo(SecretaryEntity.cpf, event.cpfEqualsToString);
      }
      if (event.birthdayEqualsToBool) {
        query.whereEqualTo(SecretaryEntity.birthday, event.birthdayEqualsTo);
      }
      query.whereEqualTo(
          SecretaryEntity.seller,
          (ParseObject(UserProfileEntity.className)..objectId = state.seller.id)
              .toPointer());
      query.orderByDescending('updatedAt');
      List<SecretaryModel> secretaryModelListGet =
          await _secretaryRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: SecretarySearchStateStatus.success,
        secretaryModelList: secretaryModelListGet,
        query: query,
      ));
    } catch (e) {
      print(e);
      emit(
        state.copyWith(
            status: SecretarySearchStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onSecretarySearchEventPreviousPage(
      SecretarySearchEventPreviousPage event,
      Emitter<SecretarySearchState> emit) async {
    emit(
      state.copyWith(
        status: SecretarySearchStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<SecretaryModel> secretaryModelListGet =
          await _secretaryRepository.list(
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
        status: SecretarySearchStateStatus.success,
        secretaryModelList: secretaryModelListGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: SecretarySearchStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileSearchEventNextPage(
      SecretarySearchEventNextPage event,
      Emitter<SecretarySearchState> emit) async {
    emit(
      state.copyWith(status: SecretarySearchStateStatus.loading),
    );
    List<SecretaryModel> secretaryModelListGet =
        await _secretaryRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (secretaryModelListGet.isEmpty) {
      emit(state.copyWith(
        status: SecretarySearchStateStatus.success,
        // firstPage: false,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: SecretarySearchStateStatus.success,
        secretaryModelList: secretaryModelListGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onSecretarySearchEventUpdateList(
      SecretarySearchEventUpdateList event,
      Emitter<SecretarySearchState> emit) {
    int index = state.secretaryModelList
        .indexWhere((model) => model.id == event.secretaryModel.id);
    if (index >= 0) {
      List<SecretaryModel> secretaryModelListTemp = [
        ...state.secretaryModelList
      ];
      secretaryModelListTemp
          .replaceRange(index, index + 1, [event.secretaryModel]);
      emit(state.copyWith(secretaryModelList: secretaryModelListTemp));
    }
  }
}
