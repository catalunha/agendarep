import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/clinic_model.dart';
import '../../../../core/models/secretary_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/clinic_repository.dart';
import 'clinic_save_event.dart';
import 'clinic_save_state.dart';

class ClinicSaveBloc extends Bloc<ClinicSaveEvent, ClinicSaveState> {
  final ClinicRepository _clinicRepository;
  final UserProfileModel _seller;
  ClinicSaveBloc({
    required ClinicModel? clinicModel,
    required ClinicRepository clinicRepository,
    required UserProfileModel seller,
  })  : _clinicRepository = clinicRepository,
        _seller = seller,
        super(ClinicSaveState.initial(clinicModel)) {
    on<ClinicSaveEventFormSubmitted>(_onClinicSaveEventFormSubmitted);
    on<ClinicSaveEventDelete>(_onClinicSaveEventDelete);
    on<ClinicSaveEventAddSecretary>(_onClinicSaveEventAddSecretary);
    on<ClinicSaveEventRemoveSecretary>(_onClinicSaveEventRemoveSecretary);
    on<ClinicSaveEventAddMedical>(_onClinicSaveEventAddMedical);
    on<ClinicSaveEventAddAddress>(_onClinicSaveEventAddAddress);
  }

  FutureOr<void> _onClinicSaveEventFormSubmitted(
      ClinicSaveEventFormSubmitted event, Emitter<ClinicSaveState> emit) async {
    emit(state.copyWith(status: ClinicSaveStateStatus.loading));
    try {
      ClinicModel clinicModel;
      if (state.model == null) {
        clinicModel = ClinicModel(
          seller: _seller,
          medical: state.medical,
          address: state.address,
          room: event.room,
          phone: event.phone,
          description: event.description,
        );
      } else {
        clinicModel = state.model!.copyWith(
          medical: state.medical,
          address: state.address,
          room: event.room,
          phone: event.phone,
          description: event.description,
        );
      }
      String clinicModelId = await _clinicRepository.update(clinicModel);
      List<SecretaryModel> secretariesResult =
          await updateRelationSecretary(clinicModelId);

      clinicModel = clinicModel.copyWith(
          id: clinicModelId, secretaries: secretariesResult);

      emit(state.copyWith(
          model: clinicModel,
          secretariesOriginal: secretariesResult,
          secretariesUpdated: secretariesResult,
          status: ClinicSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: ClinicSaveStateStatus.error, error: 'Erro ao salvar clinic'));
    }
  }

  FutureOr<void> _onClinicSaveEventDelete(
      ClinicSaveEventDelete event, Emitter<ClinicSaveState> emit) async {
    try {
      emit(state.copyWith(status: ClinicSaveStateStatus.loading));
      await _clinicRepository.delete(state.model!.id!);
      emit(state.copyWith(status: ClinicSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: ClinicSaveStateStatus.error, error: 'Erro ao salvar clinic'));
    }
  }

  FutureOr<void> _onClinicSaveEventAddSecretary(
      ClinicSaveEventAddSecretary event, Emitter<ClinicSaveState> emit) {
    List<SecretaryModel> secretariesTemp = [...state.secretariesUpdated];
    secretariesTemp.add(event.model);
    emit(state.copyWith(secretariesUpdated: secretariesTemp));
  }

  FutureOr<void> _onClinicSaveEventRemoveSecretary(
      ClinicSaveEventRemoveSecretary event, Emitter<ClinicSaveState> emit) {
    List<SecretaryModel> secretariesTemp = [...state.secretariesUpdated];
    secretariesTemp.removeWhere((element) => element.id == event.model.id);
    emit(state.copyWith(secretariesUpdated: secretariesTemp));
  }

  Future<List<SecretaryModel>> updateRelationSecretary(String modelId) async {
    List<SecretaryModel> listResult = [];
    List<SecretaryModel> listFinal = [];
    listResult.addAll([...state.secretariesUpdated]);
    listFinal.addAll([...state.secretariesOriginal]);
    for (var original in state.secretariesOriginal) {
      int index = state.secretariesUpdated
          .indexWhere((model) => model.id == original.id);
      if (index < 0) {
        await _clinicRepository.updateRelationSecretaries(
            modelId, [original.id!], false);
        listFinal.removeWhere((element) => element.id == original.id);
      } else {
        listResult.removeWhere((element) => element.id == original.id);
      }
    }
    for (var expertiseResult in listResult) {
      await _clinicRepository.updateRelationSecretaries(
          modelId, [expertiseResult.id!], true);
      listFinal.add(expertiseResult);
    }
    return listFinal;
  }

  FutureOr<void> _onClinicSaveEventAddMedical(
      ClinicSaveEventAddMedical event, Emitter<ClinicSaveState> emit) {
    emit(state.copyWith(medical: event.model));
  }

  FutureOr<void> _onClinicSaveEventAddAddress(
      ClinicSaveEventAddAddress event, Emitter<ClinicSaveState> emit) {
    emit(state.copyWith(address: event.model));
  }
}
