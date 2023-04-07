import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/address_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/address_repository.dart';
import '../../../../data/b4a/entity/address_entity.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'address_search_event.dart';
import 'address_search_state.dart';

class AddressSearchBloc extends Bloc<AddressSearchEvent, AddressSearchState> {
  final AddressRepository _addressRepository;
  AddressSearchBloc(
      {required AddressRepository addressRepository,
      required UserProfileModel seller})
      : _addressRepository = addressRepository,
        super(AddressSearchState.initial(seller: seller)) {
    on<AddressSearchEventFormSubmitted>(_onAddressSearchEventFormSubmitted);
    on<AddressSearchEventPreviousPage>(_onAddressSearchEventPreviousPage);
    on<AddressSearchEventNextPage>(_onUserProfileSearchEventNextPage);
    on<AddressSearchEventUpdateList>(_onAddressSearchEventUpdateList);
    on<AddressSearchEventRemoveFromList>(_onAddressSearchEventRemoveFromList);
  }

  FutureOr<void> _onAddressSearchEventFormSubmitted(
      AddressSearchEventFormSubmitted event,
      Emitter<AddressSearchState> emit) async {
    emit(state.copyWith(
      status: AddressSearchStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(AddressEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(AddressEntity.className));

      if (event.nameContainsBool) {
        query.whereContains(AddressEntity.name, event.nameContainsString);
      }
      if (event.phoneEqualsToBool) {
        query.whereEqualTo(AddressEntity.phone, event.phoneEqualsToString);
      }
      query.whereEqualTo(
          AddressEntity.seller,
          (ParseObject(UserProfileEntity.className)..objectId = state.seller.id)
              .toPointer());
      query.orderByDescending('updatedAt');
      List<AddressModel> addressModelListGet = await _addressRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );

      emit(state.copyWith(
        status: AddressSearchStateStatus.success,
        list: addressModelListGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: AddressSearchStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onAddressSearchEventPreviousPage(
      AddressSearchEventPreviousPage event,
      Emitter<AddressSearchState> emit) async {
    emit(
      state.copyWith(
        status: AddressSearchStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<AddressModel> addressModelListGet = await _addressRepository.list(
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
        status: AddressSearchStateStatus.success,
        list: addressModelListGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: AddressSearchStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileSearchEventNextPage(
      AddressSearchEventNextPage event,
      Emitter<AddressSearchState> emit) async {
    emit(
      state.copyWith(status: AddressSearchStateStatus.loading),
    );
    List<AddressModel> addressModelListGet = await _addressRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (addressModelListGet.isEmpty) {
      emit(state.copyWith(
        status: AddressSearchStateStatus.success,
        // firstPage: false,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: AddressSearchStateStatus.success,
        list: addressModelListGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onAddressSearchEventUpdateList(
      AddressSearchEventUpdateList event, Emitter<AddressSearchState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<AddressModel> addressModelListTemp = [...state.list];
      addressModelListTemp.replaceRange(index, index + 1, [event.model]);
      emit(state.copyWith(list: addressModelListTemp));
    }
  }

  FutureOr<void> _onAddressSearchEventRemoveFromList(
      AddressSearchEventRemoveFromList event,
      Emitter<AddressSearchState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.modelId);
    if (index >= 0) {
      List<AddressModel> addressModelListTemp = [...state.list];
      addressModelListTemp.removeAt(index);
      emit(state.copyWith(list: addressModelListTemp));
    }
  }
}
