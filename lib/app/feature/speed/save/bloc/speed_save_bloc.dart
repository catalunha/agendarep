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
    on<SpeedSaveEventAddRegion>(_onSpeedSaveEventAddRegion);
    on<SpeedSaveEventRemoveRegion>(_onSpeedSaveEventRemoveRegion);
  }

  FutureOr<void> _onSpeedSaveEventFormSubmitted(
      SpeedSaveEventFormSubmitted event, Emitter<SpeedSaveState> emit) {
    emit(state.copyWith(status: SpeedSaveStateStatus.loading));
    try {
      emit(state.copyWith(status: SpeedSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: SpeedSaveStateStatus.error, error: 'Erro ao salvar speed'));
    }
  }

  FutureOr<void> _onSpeedSaveEventAddRegion(
      SpeedSaveEventAddRegion event, Emitter<SpeedSaveState> emit) {
    emit(state.copyWith(region: event.model));
  }

  FutureOr<void> _onSpeedSaveEventRemoveRegion(
      SpeedSaveEventRemoveRegion event, Emitter<SpeedSaveState> emit) {
    emit(state.copyWith(regionReset: true));
  }
}
