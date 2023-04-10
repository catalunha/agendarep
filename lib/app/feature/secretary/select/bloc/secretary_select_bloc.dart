import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/secretary_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/secretary_repository.dart';
import '../../../../data/b4a/entity/secretary_entity.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'secretary_select_event.dart';
import 'secretary_select_state.dart';

class SecretarySelectBloc
    extends Bloc<SecretarySelectEvent, SecretarySelectState> {
  final SecretaryRepository _secretaryRepository;
  SecretarySelectBloc(
      {required SecretaryRepository secretaryRepository,
      required UserProfileModel seller})
      : _secretaryRepository = secretaryRepository,
        super(SecretarySelectState.initial(seller: seller)) {
    on<SecretarySelectEventStartQuery>(_onSecretarySelectEventStartQuery);
    on<SecretarySelectEventPreviousPage>(_onSecretarySelectEventPreviousPage);
    on<SecretarySelectEventNextPage>(_onSecretarySelectEventNextPage);
    on<SecretarySelectEventFormSubmitted>(_onSecretarySelectEventFormSubmitted);
    add(SecretarySelectEventStartQuery());
  }

  FutureOr<void> _onSecretarySelectEventStartQuery(
      SecretarySelectEventStartQuery event,
      Emitter<SecretarySelectState> emit) async {
    emit(state.copyWith(
      status: SecretarySelectStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(SecretaryEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(SecretaryEntity.className));
      query.keysToReturn(['name']);

      query.whereEqualTo(
          SecretaryEntity.seller,
          (ParseObject(UserProfileEntity.className)..objectId = state.seller.id)
              .toPointer());
      query.orderByDescending('updatedAt');
      List<SecretaryModel> listGet = await _secretaryRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: SecretarySelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: SecretarySelectStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onSecretarySelectEventPreviousPage(
      SecretarySelectEventPreviousPage event,
      Emitter<SecretarySelectState> emit) async {
    emit(
      state.copyWith(
        status: SecretarySelectStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<SecretaryModel> listGet = await _secretaryRepository.list(
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
        status: SecretarySelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: SecretarySelectStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onSecretarySelectEventNextPage(
      SecretarySelectEventNextPage event,
      Emitter<SecretarySelectState> emit) async {
    emit(
      state.copyWith(status: SecretarySelectStateStatus.loading),
    );
    List<SecretaryModel> listGet = await _secretaryRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: SecretarySelectStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: SecretarySelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onSecretarySelectEventFormSubmitted(
      SecretarySelectEventFormSubmitted event,
      Emitter<SecretarySelectState> emit) {
    if (event.name.isEmpty) {
      emit(state.copyWith(listFiltered: state.list));
    } else {
      List<SecretaryModel> listTemp;
      listTemp = state.list.where((e) => e.name!.contains(event.name)).toList();
      emit(state.copyWith(listFiltered: listTemp));
    }
  }
}
