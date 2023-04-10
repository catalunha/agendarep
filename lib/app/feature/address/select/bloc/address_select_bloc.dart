import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/address_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/address_repository.dart';
import '../../../../data/b4a/entity/address_entity.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'address_select_event.dart';
import 'address_select_state.dart';

class AddressSelectBloc extends Bloc<AddressSelectEvent, AddressSelectState> {
  final AddressRepository _addressRepository;
  AddressSelectBloc(
      {required AddressRepository addressRepository,
      required UserProfileModel seller})
      : _addressRepository = addressRepository,
        super(AddressSelectState.initial(seller: seller)) {
    on<AddressSelectEventStartQuery>(_onAddressSelectEventStartQuery);
    on<AddressSelectEventPreviousPage>(_onAddressSelectEventPreviousPage);
    on<AddressSelectEventNextPage>(_onAddressSelectEventNextPage);
    on<AddressSelectEventFormSubmitted>(_onAddressSelectEventFormSubmitted);
    add(AddressSelectEventStartQuery());
  }

  FutureOr<void> _onAddressSelectEventStartQuery(
      AddressSelectEventStartQuery event,
      Emitter<AddressSelectState> emit) async {
    emit(state.copyWith(
      status: AddressSelectStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(AddressEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(AddressEntity.className));
      query.keysToReturn(['name']);

      query.whereEqualTo(
          AddressEntity.seller,
          (ParseObject(UserProfileEntity.className)..objectId = state.seller.id)
              .toPointer());
      query.orderByDescending('updatedAt');
      List<AddressModel> listGet = await _addressRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: AddressSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: AddressSelectStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onAddressSelectEventPreviousPage(
      AddressSelectEventPreviousPage event,
      Emitter<AddressSelectState> emit) async {
    emit(
      state.copyWith(
        status: AddressSelectStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<AddressModel> listGet = await _addressRepository.list(
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
        status: AddressSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: AddressSelectStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onAddressSelectEventNextPage(AddressSelectEventNextPage event,
      Emitter<AddressSelectState> emit) async {
    emit(
      state.copyWith(status: AddressSelectStateStatus.loading),
    );
    List<AddressModel> listGet = await _addressRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: AddressSelectStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: AddressSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onAddressSelectEventFormSubmitted(
      AddressSelectEventFormSubmitted event, Emitter<AddressSelectState> emit) {
    if (event.name.isEmpty) {
      emit(state.copyWith(listFiltered: state.list));
    } else {
      List<AddressModel> listTemp;
      listTemp = state.list.where((e) => e.name!.contains(event.name)).toList();
      emit(state.copyWith(listFiltered: listTemp));
    }
  }
}
