import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/medical_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/medical_repository.dart';
import 'medical_save_event.dart';
import 'medical_save_state.dart';

class MedicalSaveBloc extends Bloc<MedicalSaveEvent, MedicalSaveState> {
  final MedicalRepository _medicalRepository;
  final UserProfileModel _seller;
  MedicalSaveBloc({
    required MedicalModel? medicalModel,
    required MedicalRepository medicalRepository,
    required UserProfileModel seller,
  })  : _medicalRepository = medicalRepository,
        _seller = seller,
        super(MedicalSaveState.initial(medicalModel)) {
    on<MedicalSaveEventFormSubmitted>(_onMedicalSaveEventFormSubmitted);
    on<MedicalSaveEventDelete>(_onMedicalSaveEventDelete);
    on<MedicalSaveEventAddExpertise>(_onMedicalSaveEventAddExpertise);
    on<MedicalSaveEventRemoveExpertise>(_onMedicalSaveEventRemoveExpertise);
  }

  FutureOr<void> _onMedicalSaveEventFormSubmitted(
      MedicalSaveEventFormSubmitted event,
      Emitter<MedicalSaveState> emit) async {
    emit(state.copyWith(status: MedicalSaveStateStatus.loading));
    try {
      MedicalModel medicalModel;
      if (state.medicalModel == null) {
        medicalModel = MedicalModel(
          seller: _seller,
          email: event.email,
          name: event.name,
          phone: event.phone,
          crm: event.crm,
          isBlocked: event.isBlocked,
          birthday: event.birthday,
        );
      } else {
        medicalModel = state.medicalModel!.copyWith(
          email: event.email,
          name: event.name,
          phone: event.phone,
          crm: event.crm,
          isBlocked: event.isBlocked,
          birthday: event.birthday,
        );
      }
      String medicalModelId = await _medicalRepository.update(medicalModel);
      List<ExpertiseModel> expertisesResult =
          await updateRelationExpertise(medicalModelId);

      medicalModel = medicalModel.copyWith(
          id: medicalModelId, expertises: expertisesResult);

      emit(state.copyWith(
          medicalModel: medicalModel,
          expertisesOriginal: expertisesResult,
          expertisesUpdated: expertisesResult,
          status: MedicalSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: MedicalSaveStateStatus.error,
          error: 'Erro ao salvar medical'));
    }
  }

  FutureOr<void> _onMedicalSaveEventDelete(
      MedicalSaveEventDelete event, Emitter<MedicalSaveState> emit) async {
    try {
      emit(state.copyWith(status: MedicalSaveStateStatus.loading));
      await _medicalRepository.delete(state.medicalModel!.id!);
      emit(state.copyWith(status: MedicalSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: MedicalSaveStateStatus.error,
          error: 'Erro ao salvar medical'));
    }
  }

  FutureOr<void> _onMedicalSaveEventAddExpertise(
      MedicalSaveEventAddExpertise event, Emitter<MedicalSaveState> emit) {
    int index = state.expertisesUpdated
        .indexWhere((model) => model.id == event.model.id);
    if (index < 0) {
      List<ExpertiseModel> expertisesTemp = [...state.expertisesUpdated];
      expertisesTemp.add(event.model);
      emit(state.copyWith(expertisesUpdated: expertisesTemp));
    }
  }

  FutureOr<void> _onMedicalSaveEventRemoveExpertise(
      MedicalSaveEventRemoveExpertise event, Emitter<MedicalSaveState> emit) {
    List<ExpertiseModel> expertisesTemp = [...state.expertisesUpdated];
    expertisesTemp
        .removeWhere((element) => element.id == event.expertiseModel.id);
    emit(state.copyWith(expertisesUpdated: expertisesTemp));
  }

  Future<List<ExpertiseModel>> updateRelationExpertise(String modelId) async {
    List<ExpertiseModel> listResult = [];
    List<ExpertiseModel> listFinal = [];
    listResult.addAll([...state.expertisesUpdated]);
    listFinal.addAll([...state.expertisesOriginal]);
    for (var expertiseOriginal in state.expertisesOriginal) {
      int index = state.expertisesUpdated
          .indexWhere((model) => model.id == expertiseOriginal.id);
      if (index < 0) {
        await _medicalRepository.updateRelationExpertises(
            modelId, [expertiseOriginal.id!], false);
        listFinal.removeWhere((element) => element.id == expertiseOriginal.id);
      } else {
        listResult.removeWhere((element) => element.id == expertiseOriginal.id);
      }
    }
    for (var expertiseResult in listResult) {
      await _medicalRepository.updateRelationExpertises(
          modelId, [expertiseResult.id!], true);
      listFinal.add(expertiseResult);
    }
    return listFinal;
  }
}
