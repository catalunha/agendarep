import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/clinic_model.dart';
import '../../../../core/models/expertise_model.dart';
import '../../../../core/models/schedule_models.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/clinic_repository.dart';
import '../../../../core/repositories/schedule_repository.dart';
import '../../../../data/b4a/entity/clinic_entity.dart';
import '../../../../data/b4a/entity/medical_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'schedule_save_event.dart';
import 'schedule_save_state.dart';

class ScheduleSaveBloc extends Bloc<ScheduleSaveEvent, ScheduleSaveState> {
  final ScheduleRepository _scheduleRepository;
  final UserProfileModel _seller;
  final ClinicRepository _clinicRepository;

  ScheduleSaveBloc({
    required ScheduleModel? scheduleModel,
    required ScheduleRepository scheduleRepository,
    required ClinicRepository clinicRepository,
    required UserProfileModel seller,
  })  : _scheduleRepository = scheduleRepository,
        _clinicRepository = clinicRepository,
        _seller = seller,
        super(ScheduleSaveState.initial(scheduleModel)) {
    on<ScheduleSaveEventFormSubmitted>(_onScheduleSaveEventFormSubmitted);
    on<ScheduleSaveEventDelete>(_onScheduleSaveEventDelete);
    on<ScheduleSaveEventAddMedical>(_onScheduleSaveEventAddMedical);
    on<ScheduleSaveEventAddExpertise>(_onScheduleSaveEventAddExpertise);
    on<ScheduleSaveEventRemoveExpertise>(_onScheduleSaveEventRemoveExpertise);
    on<ScheduleSaveEventAddClinic>(_onScheduleSaveEventAddClinic);
    on<ScheduleSaveEventRemoveClinic>(_onScheduleSaveEventRemoveClinic);
    on<ScheduleSaveEventUpdateHourInWeekday>(
        _onScheduleSaveEventUpdateHourInWeekday);
  }

  FutureOr<void> _onScheduleSaveEventFormSubmitted(
      ScheduleSaveEventFormSubmitted event,
      Emitter<ScheduleSaveState> emit) async {
    emit(state.copyWith(status: ScheduleSaveStateStatus.loading));
    try {
      print('state.expertises.length: ${state.expertises.length}');
      print('state.clinics.length: ${state.clinics.length}');
      if (state.expertises.length == 1 && state.clinics.length == 1) {
        ScheduleModel scheduleModel;
        var mondayHours = state.mondayHours;
        var tuesdayHours = state.tuesdayHours;
        var wednesdayHours = state.wednesdayHours;
        var thursdayHours = state.thursdayHours;
        var fridayHours = state.fridayHours;
        var saturdayHours = state.saturdayHours;
        var sundayHours = state.sundayHours;
        mondayHours.sort();
        tuesdayHours.sort();
        wednesdayHours.sort();
        thursdayHours.sort();
        fridayHours.sort();
        saturdayHours.sort();
        sundayHours.sort();
        if (state.model == null) {
          scheduleModel = ScheduleModel(
            seller: _seller,
            medical: state.medical,
            expertise: state.expertises[0],
            clinic: state.clinics[0],
            justSchedule: event.justSchedule,
            limitedSellers: event.limitedSellers,
            description: event.description,
            mondayHours: mondayHours,
            tuesdayHours: tuesdayHours,
            wednesdayHours: wednesdayHours,
            thursdayHours: thursdayHours,
            fridayHours: fridayHours,
            saturdayHours: saturdayHours,
            sundayHours: sundayHours,
          );
        } else {
          scheduleModel = state.model!.copyWith(
            medical: state.medical,
            expertise: state.expertises[0],
            clinic: state.clinics[0],
            justSchedule: event.justSchedule,
            limitedSellers: event.limitedSellers,
            description: event.description,
            mondayHours: mondayHours,
            tuesdayHours: tuesdayHours,
            wednesdayHours: wednesdayHours,
            thursdayHours: thursdayHours,
            fridayHours: fridayHours,
            saturdayHours: saturdayHours,
            sundayHours: sundayHours,
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
      ScheduleSaveEventAddMedical event,
      Emitter<ScheduleSaveState> emit) async {
    try {
      emit(state.copyWith(status: ScheduleSaveStateStatus.loading));
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(ClinicEntity.className));
      query.whereEqualTo(
          ClinicEntity.medical,
          (ParseObject(MedicalEntity.className)..objectId = event.model.id)
              .toPointer());
      query.orderByDescending('updatedAt');
      List<ClinicModel> clinicModelListGet = await _clinicRepository.list(
        query,
        Pagination(page: 1, limit: 10),
      );
      print('clinicModelListGet: $clinicModelListGet');
      emit(state.copyWith(
          status: ScheduleSaveStateStatus.updated,
          medical: event.model,
          expertises: event.model.expertises,
          clinics: clinicModelListGet));
    } catch (e) {
      emit(state.copyWith(
          status: ScheduleSaveStateStatus.error,
          error: 'Erro ao buscar medico'));
    }
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

  FutureOr<void> _onScheduleSaveEventUpdateHourInWeekday(
      ScheduleSaveEventUpdateHourInWeekday event,
      Emitter<ScheduleSaveState> emit) {
    if (event.weekday == 1) {
      int index = state.sundayHours.indexWhere((hour) => hour == event.hour);
      List<int> temp = [...state.sundayHours];
      if (index < 0) {
        temp.add(event.hour);
        emit(state.copyWith(sundayHours: temp));
      } else {
        temp.removeWhere((hour) => hour == event.hour);
        emit(state.copyWith(sundayHours: temp));
      }
    }
    if (event.weekday == 2) {
      int index = state.mondayHours.indexWhere((hour) => hour == event.hour);
      List<int> temp = [...state.mondayHours];
      if (index < 0) {
        temp.add(event.hour);
        emit(state.copyWith(mondayHours: temp));
      } else {
        temp.removeWhere((hour) => hour == event.hour);
        emit(state.copyWith(mondayHours: temp));
      }
    }
    if (event.weekday == 3) {
      int index = state.tuesdayHours.indexWhere((hour) => hour == event.hour);
      List<int> temp = [...state.tuesdayHours];
      if (index < 0) {
        temp.add(event.hour);
        emit(state.copyWith(tuesdayHours: temp));
      } else {
        temp.removeWhere((hour) => hour == event.hour);
        emit(state.copyWith(tuesdayHours: temp));
      }
    }
    if (event.weekday == 4) {
      int index = state.wednesdayHours.indexWhere((hour) => hour == event.hour);
      List<int> temp = [...state.wednesdayHours];
      if (index < 0) {
        temp.add(event.hour);
        emit(state.copyWith(wednesdayHours: temp));
      } else {
        temp.removeWhere((hour) => hour == event.hour);
        emit(state.copyWith(wednesdayHours: temp));
      }
    }
    if (event.weekday == 5) {
      int index = state.thursdayHours.indexWhere((hour) => hour == event.hour);
      List<int> temp = [...state.thursdayHours];
      if (index < 0) {
        temp.add(event.hour);
        emit(state.copyWith(thursdayHours: temp));
      } else {
        temp.removeWhere((hour) => hour == event.hour);
        emit(state.copyWith(thursdayHours: temp));
      }
    }
    if (event.weekday == 6) {
      int index = state.fridayHours.indexWhere((hour) => hour == event.hour);
      List<int> temp = [...state.fridayHours];
      if (index < 0) {
        temp.add(event.hour);
        emit(state.copyWith(fridayHours: temp));
      } else {
        temp.removeWhere((hour) => hour == event.hour);
        emit(state.copyWith(fridayHours: temp));
      }
    }
    if (event.weekday == 7) {
      int index = state.saturdayHours.indexWhere((hour) => hour == event.hour);
      List<int> temp = [...state.saturdayHours];
      if (index < 0) {
        temp.add(event.hour);
        emit(state.copyWith(saturdayHours: temp));
      } else {
        temp.removeWhere((hour) => hour == event.hour);
        emit(state.copyWith(saturdayHours: temp));
      }
    }
  }
}
