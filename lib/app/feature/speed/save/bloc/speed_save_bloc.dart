import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/region_repository.dart';
import 'speed_save_event.dart';
import 'speed_save_state.dart';

class SpeedSaveBloc extends Bloc<SpeedSaveEvent, SpeedSaveState> {
  final UserProfileModel _seller;
  final RegionRepository _regionRepository;
  SpeedSaveBloc({
    required UserProfileModel seller,
    required RegionRepository regionRepository,
  })  : _seller = seller,
        _regionRepository = regionRepository,
        super(SpeedSaveState.initial()) {
    on<SpeedSaveEventFormSubmitted>(_onSpeedSaveEventFormSubmitted);
    on<SpeedSaveEventSetRegion>(_onSpeedSaveEventSetRegion);
    on<SpeedSaveEventSetAddress>(_onSpeedSaveEventSetAddress);
    on<SpeedSaveEventSetSecretary>(_onSpeedSaveEventSetSecretary);
    on<SpeedSaveEventSetMedical>(_onSpeedSaveEventSetMedical);
    on<SpeedSaveEventSetExpertise>(_onSpeedSaveEventSetExpertise);
    on<SpeedSaveEventSetClinic>(_onSpeedSaveEventSetClinic);
    on<SpeedSaveEventUpdateHourInWeekday>(_onSpeedSaveEventUpdateHourInWeekday);
  }

  FutureOr<void> _onSpeedSaveEventFormSubmitted(
      SpeedSaveEventFormSubmitted event, Emitter<SpeedSaveState> emit) async {
    emit(state.copyWith(status: SpeedSaveStateStatus.loading));
    try {
      print(event.regionUf);
      print(state.region);
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: SpeedSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: SpeedSaveStateStatus.error, error: 'Erro ao salvar speed'));
    }
  }

  FutureOr<void> _onSpeedSaveEventSetRegion(
      SpeedSaveEventSetRegion event, Emitter<SpeedSaveState> emit) {
    if (event.model == null) {
      emit(state.copyWith(regionReset: true));
    } else {
      emit(state.copyWith(region: event.model));
    }
  }

  FutureOr<void> _onSpeedSaveEventSetAddress(
      SpeedSaveEventSetAddress event, Emitter<SpeedSaveState> emit) {
    if (event.model == null) {
      emit(state.copyWith(addressReset: true));
    } else {
      emit(state.copyWith(address: event.model));
    }
  }

  FutureOr<void> _onSpeedSaveEventSetSecretary(
      SpeedSaveEventSetSecretary event, Emitter<SpeedSaveState> emit) {
    if (event.model == null) {
      emit(state.copyWith(secretaryReset: true));
    } else {
      emit(state.copyWith(secretary: event.model));
    }
  }

  FutureOr<void> _onSpeedSaveEventSetMedical(
      SpeedSaveEventSetMedical event, Emitter<SpeedSaveState> emit) {
    if (event.model == null) {
      emit(state.copyWith(medicalReset: true));
    } else {
      emit(state.copyWith(medical: event.model));
    }
  }

  FutureOr<void> _onSpeedSaveEventSetExpertise(
      SpeedSaveEventSetExpertise event, Emitter<SpeedSaveState> emit) {
    if (event.model == null) {
      emit(state.copyWith(expertiseReset: true));
    } else {
      emit(state.copyWith(expertise: event.model));
    }
  }

  FutureOr<void> _onSpeedSaveEventSetClinic(
      SpeedSaveEventSetClinic event, Emitter<SpeedSaveState> emit) {
    if (event.model == null) {
      emit(state.copyWith(clinicReset: true));
    } else {
      emit(state.copyWith(clinic: event.model));
    }
  }

  FutureOr<void> _onSpeedSaveEventUpdateHourInWeekday(
      SpeedSaveEventUpdateHourInWeekday event, Emitter<SpeedSaveState> emit) {
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
