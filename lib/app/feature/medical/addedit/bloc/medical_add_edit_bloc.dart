import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/medical_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/medical_repository.dart';
import 'medical_add_edit_event.dart';
import 'medical_add_edit_state.dart';

class MedicalAddEditBloc
    extends Bloc<MedicalAddEditEvent, MedicalAddEditState> {
  final MedicalRepository _medicalRepository;
  final UserProfileModel _seller;
  MedicalAddEditBloc({
    required MedicalModel? medicalModel,
    required MedicalRepository medicalRepository,
    required UserProfileModel seller,
  })  : _medicalRepository = medicalRepository,
        _seller = seller,
        super(MedicalAddEditState.initial(medicalModel)) {
    on<MedicalAddEditEventFormSubmitted>(_onMedicalAddEditEventFormSubmitted);
    on<MedicalAddEditEventDelete>(_onMedicalAddEditEventDelete);
    on<MedicalAddEditEventAddExpertise>(_onMedicalAddEditEventAddExpertise);
    on<MedicalAddEditEventRemoveExpertise>(
        _onMedicalAddEditEventRemoveExpertise);
  }

  FutureOr<void> _onMedicalAddEditEventFormSubmitted(
      MedicalAddEditEventFormSubmitted event,
      Emitter<MedicalAddEditState> emit) async {
    emit(state.copyWith(status: MedicalAddEditStateStatus.loading));
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
          description: event.description,
        );
      } else {
        medicalModel = state.medicalModel!.copyWith(
          email: event.email,
          name: event.name,
          phone: event.phone,
          crm: event.crm,
          isBlocked: event.isBlocked,
          birthday: event.birthday,
          description: event.description,
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
          status: MedicalAddEditStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: MedicalAddEditStateStatus.error,
          error: 'Erro ao salvar medical'));
    }
  }

  FutureOr<void> _onMedicalAddEditEventDelete(MedicalAddEditEventDelete event,
      Emitter<MedicalAddEditState> emit) async {
    try {
      emit(state.copyWith(status: MedicalAddEditStateStatus.loading));
      await _medicalRepository.delete(state.medicalModel!.id!);
      emit(state.copyWith(status: MedicalAddEditStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: MedicalAddEditStateStatus.error,
          error: 'Erro ao salvar medical'));
    }
  }

  FutureOr<void> _onMedicalAddEditEventAddExpertise(
      MedicalAddEditEventAddExpertise event,
      Emitter<MedicalAddEditState> emit) {
    List<ExpertiseModel> expertisesTemp = [...state.expertisesUpdated];
    expertisesTemp.add(event.expertiseModel);
    emit(state.copyWith(expertisesUpdated: expertisesTemp));
  }

  FutureOr<void> _onMedicalAddEditEventRemoveExpertise(
      MedicalAddEditEventRemoveExpertise event,
      Emitter<MedicalAddEditState> emit) {
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
