import 'dart:async';

import 'package:bloc/bloc.dart';

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

      medicalModel = medicalModel.copyWith(id: medicalModelId);

      emit(state.copyWith(
          medicalModel: medicalModel,
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
}
