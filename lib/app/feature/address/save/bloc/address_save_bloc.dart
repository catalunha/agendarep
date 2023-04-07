import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/address_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/address_repository.dart';
import 'address_save_event.dart';
import 'address_save_state.dart';

class AddressSaveBloc extends Bloc<AddressSaveEvent, AddressSaveState> {
  final AddressRepository _addressRepository;
  final UserProfileModel _seller;
  AddressSaveBloc({
    required AddressModel? model,
    required AddressRepository addressRepository,
    required UserProfileModel seller,
  })  : _addressRepository = addressRepository,
        _seller = seller,
        super(AddressSaveState.initial(model)) {
    on<AddressSaveEventFormSubmitted>(_onAddressSaveEventFormSubmitted);
    on<AddressSaveEventDelete>(_onAddressSaveEventDelete);
  }

  FutureOr<void> _onAddressSaveEventFormSubmitted(
      AddressSaveEventFormSubmitted event,
      Emitter<AddressSaveState> emit) async {
    emit(state.copyWith(status: AddressSaveStateStatus.loading));
    try {
      AddressModel model;
      if (state.model == null) {
        model = AddressModel(
            seller: _seller,
            name: event.name,
            phone: event.phone,
            description: event.description,
            parseGeoPoint: event.latitude != null && event.longitude != null
                ? ParseGeoPoint(
                    latitude: event.latitude!, longitude: event.longitude!)
                : null,
            region: event.regionModel);
      } else {
        model = state.model!.copyWith(
            name: event.name,
            phone: event.phone,
            description: event.description,
            parseGeoPoint: event.latitude != null && event.longitude != null
                ? ParseGeoPoint(
                    latitude: event.latitude!, longitude: event.longitude!)
                : null,
            region: event.regionModel);
      }
      String modelId = await _addressRepository.update(model);

      model = model.copyWith(id: modelId);

      emit(
          state.copyWith(model: model, status: AddressSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: AddressSaveStateStatus.error,
          error: 'Erro ao salvar address'));
    }
  }

  FutureOr<void> _onAddressSaveEventDelete(
      AddressSaveEventDelete event, Emitter<AddressSaveState> emit) async {
    try {
      emit(state.copyWith(status: AddressSaveStateStatus.loading));
      await _addressRepository.delete(state.model!.id!);
      emit(state.copyWith(status: AddressSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: AddressSaveStateStatus.error,
          error: 'Erro ao deletar address'));
    }
  }
}
