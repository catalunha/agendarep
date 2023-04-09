import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/clinic_model.dart';
import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/schedule_models.dart';
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
    on<ScheduleSaveEventAddMedical>(_onScheduleSaveEventAddMedical);
    on<ScheduleSaveEventAddExpertise>(_onScheduleSaveEventAddExpertise);
    on<ScheduleSaveEventRemoveExpertise>(_onScheduleSaveEventRemoveExpertise);
    on<ScheduleSaveEventAddClinic>(_onScheduleSaveEventAddClinic);
    on<ScheduleSaveEventRemoveClinic>(_onScheduleSaveEventRemoveClinic);
  }

  FutureOr<void> _onScheduleSaveEventFormSubmitted(
      ScheduleSaveEventFormSubmitted event,
      Emitter<ScheduleSaveState> emit) async {
    emit(state.copyWith(status: ScheduleSaveStateStatus.loading));
    try {
      if (state.expertises.length != 1 || state.clinics.length != 1) {
        ScheduleModel scheduleModel;
        if (state.model == null) {
          scheduleModel = ScheduleModel(
            seller: _seller,
            medical: state.medical,
            expertise: state.expertises[0],
            clinic: state.clinics[0],
            justSchedule: event.justSchedule,
            limitedSellers: event.limitedSellers,
            description: event.description,
            mondayHours: state.mondayHours,
            tuesdayHours: state.tuesdayHours,
            wednesdayHours: state.wednesdayHours,
            thursdayHours: state.thursdayHours,
            fridayHours: state.fridayHours,
            saturdayHours: state.saturdayHours,
            sundayHours: state.sundayHours,
          );
        } else {
          scheduleModel = state.model!.copyWith(
            medical: state.medical,
            expertise: state.expertises[0],
            clinic: state.clinics[0],
            justSchedule: event.justSchedule,
            limitedSellers: event.limitedSellers,
            description: event.description,
            mondayHours: state.mondayHours,
            tuesdayHours: state.tuesdayHours,
            wednesdayHours: state.wednesdayHours,
            thursdayHours: state.thursdayHours,
            fridayHours: state.fridayHours,
            saturdayHours: state.saturdayHours,
            sundayHours: state.sundayHours,
          );
        }
        String scheduleModelId =
            await _scheduleRepository.update(scheduleModel);

        scheduleModel = scheduleModel.copyWith(id: scheduleModelId);

        emit(state.copyWith(
            model: scheduleModel, status: ScheduleSaveStateStatus.success));
      } else {
        emit(state.copyWith(
            status: ScheduleSaveStateStatus.error,
            error: 'Especialidade ou consultorio devem haver apenas um'));
      }
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

  FutureOr<void> _onScheduleSaveEventAddMedical(
      ScheduleSaveEventAddMedical event, Emitter<ScheduleSaveState> emit) {
    emit(state.copyWith(medical: event.model));
  }

  FutureOr<void> _onScheduleSaveEventAddExpertise(
      ScheduleSaveEventAddExpertise event, Emitter<ScheduleSaveState> emit) {
    int index =
        state.expertises.indexWhere((model) => model.id == event.model.id);
    if (index < 0) {
      List<ExpertiseModel> temp = [...state.expertises];
      temp.add(event.model);
      emit(state.copyWith(expertises: temp));
    }
  }

  FutureOr<void> _onScheduleSaveEventRemoveExpertise(
      ScheduleSaveEventRemoveExpertise event, Emitter<ScheduleSaveState> emit) {
    List<ExpertiseModel> temp = [...state.expertises];
    temp.removeWhere((element) => element.id == event.model.id);
    emit(state.copyWith(expertises: temp));
  }

  FutureOr<void> _onScheduleSaveEventAddClinic(
      ScheduleSaveEventAddClinic event, Emitter<ScheduleSaveState> emit) {
    int index =
        state.expertises.indexWhere((model) => model.id == event.model.id);
    if (index < 0) {
      List<ClinicModel> temp = [...state.clinics];
      temp.add(event.model);
      emit(state.copyWith(clinics: temp));
    }
  }

  FutureOr<void> _onScheduleSaveEventRemoveClinic(
      ScheduleSaveEventRemoveClinic event, Emitter<ScheduleSaveState> emit) {
    List<ClinicModel> temp = [...state.clinics];
    temp.removeWhere((element) => element.id == event.model.id);
    emit(state.copyWith(clinics: temp));
  }
}
