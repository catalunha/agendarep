import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/schedule_model.dart';
import '../../../../core/models/schedule_models.dart';
import '../../../../core/models/secretary_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/schedule_repository.dart';
import 'schedule_save_event.dart';
import 'schedule_save_state.dart';

class ScheduleSaveBloc extends Bloc<ScheduleSaveEvent, ScheduleSaveState> {
  final ScheduleRepository _scheduleRepository;
  final UserProfileModel _seller;
  ScheduleSaveBloc({
    required ScheduleModel? scheduleModel,
    required ScheduleRepository scheduleRepository,
    required UserProfileModel seller,
  })  : _scheduleRepository = scheduleRepository,
        _seller = seller,
        super(ScheduleSaveState.initial(scheduleModel)) {
    on<ScheduleSaveEventFormSubmitted>(_onScheduleSaveEventFormSubmitted);
    on<ScheduleSaveEventDelete>(_onScheduleSaveEventDelete);
    on<ScheduleSaveEventAddSecretary>(_onScheduleSaveEventAddSecretary);
    on<ScheduleSaveEventRemoveSecretary>(_onScheduleSaveEventRemoveSecretary);
    on<ScheduleSaveEventAddMedical>(_onScheduleSaveEventAddMedical);
    on<ScheduleSaveEventAddAddress>(_onScheduleSaveEventAddAddress);
  }

  FutureOr<void> _onScheduleSaveEventFormSubmitted(
      ScheduleSaveEventFormSubmitted event,
      Emitter<ScheduleSaveState> emit) async {
    emit(state.copyWith(status: ScheduleSaveStateStatus.loading));
    try {
      ScheduleModel scheduleModel;
      if (state.model == null) {
        scheduleModel = ScheduleModel(
          seller: _seller,
          medical: state.medical,
          address: state.address,
          name: event.name,
          room: event.room,
          phone: event.phone,
        );
      } else {
        scheduleModel = state.model!.copyWith(
          medical: state.medical,
          address: state.address,
          name: event.name,
          room: event.room,
          phone: event.phone,
        );
      }
      String scheduleModelId = await _scheduleRepository.update(scheduleModel);
      List<SecretaryModel> secretariesResult =
          await updateRelationSecretary(scheduleModelId);

      scheduleModel = scheduleModel.copyWith(
          id: scheduleModelId, secretaries: secretariesResult);

      emit(state.copyWith(
          model: scheduleModel,
          secretariesOriginal: secretariesResult,
          secretariesUpdated: secretariesResult,
          status: ScheduleSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: ScheduleSaveStateStatus.error,
          error: 'Erro ao salvar schedule'));
    }
  }

  FutureOr<void> _onScheduleSaveEventDelete(
      ScheduleSaveEventDelete event, Emitter<ScheduleSaveState> emit) async {
    try {
      emit(state.copyWith(status: ScheduleSaveStateStatus.loading));
      await _scheduleRepository.delete(state.model!.id!);
      emit(state.copyWith(status: ScheduleSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: ScheduleSaveStateStatus.error,
          error: 'Erro ao salvar schedule'));
    }
  }

  FutureOr<void> _onScheduleSaveEventAddSecretary(
      ScheduleSaveEventAddSecretary event, Emitter<ScheduleSaveState> emit) {
    int index = state.secretariesUpdated
        .indexWhere((model) => model.id == event.model.id);
    if (index < 0) {
      List<SecretaryModel> secretariesTemp = [...state.secretariesUpdated];
      secretariesTemp.add(event.model);
      emit(state.copyWith(secretariesUpdated: secretariesTemp));
    }
  }

  FutureOr<void> _onScheduleSaveEventRemoveSecretary(
      ScheduleSaveEventRemoveSecretary event, Emitter<ScheduleSaveState> emit) {
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
        await _scheduleRepository.updateRelationSecretaries(
            modelId, [original.id!], false);
        listFinal.removeWhere((element) => element.id == original.id);
      } else {
        listResult.removeWhere((element) => element.id == original.id);
      }
    }
    for (var expertiseResult in listResult) {
      await _scheduleRepository.updateRelationSecretaries(
          modelId, [expertiseResult.id!], true);
      listFinal.add(expertiseResult);
    }
    return listFinal;
  }

  FutureOr<void> _onScheduleSaveEventAddMedical(
      ScheduleSaveEventAddMedical event, Emitter<ScheduleSaveState> emit) {
    emit(state.copyWith(medical: event.model));
  }

  FutureOr<void> _onScheduleSaveEventAddAddress(
      ScheduleSaveEventAddAddress event, Emitter<ScheduleSaveState> emit) {
    emit(state.copyWith(address: event.model));
  }
}
