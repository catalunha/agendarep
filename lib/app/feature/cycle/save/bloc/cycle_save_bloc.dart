import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/cycle_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/cycle_repository.dart';
import 'cycle_save_event.dart';
import 'cycle_save_state.dart';

class CycleSaveBloc extends Bloc<CycleSaveEvent, CycleSaveState> {
  final CycleRepository _cycleRepository;
  final UserProfileModel _seller;
  CycleSaveBloc({
    required CycleModel? cycleModel,
    required CycleRepository cycleRepository,
    required UserProfileModel seller,
  })  : _cycleRepository = cycleRepository,
        _seller = seller,
        super(CycleSaveState.initial(cycleModel)) {
    on<CycleSaveEventFormSubmitted>(_onCycleSaveEventFormSubmitted);
    on<CycleSaveEventDelete>(_onCycleSaveEventDelete);
  }

  FutureOr<void> _onCycleSaveEventFormSubmitted(
      CycleSaveEventFormSubmitted event, Emitter<CycleSaveState> emit) async {
    emit(state.copyWith(status: CycleSaveStateStatus.loading));
    try {
      CycleModel cycleModel;
      if (state.cycleModel == null) {
        cycleModel = CycleModel(
          seller: _seller,
          name: event.name,
          isArchived: event.isArchived,
          start: event.start,
          end: event.end,
        );
      } else {
        cycleModel = state.cycleModel!.copyWith(
          name: event.name,
          isArchived: event.isArchived,
          start: event.start,
          end: event.end,
        );
      }
      String cycleModelId = await _cycleRepository.update(cycleModel);

      cycleModel = cycleModel.copyWith(id: cycleModelId);

      emit(state.copyWith(
          cycleModel: cycleModel, status: CycleSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: CycleSaveStateStatus.error, error: 'Erro ao salvar cycle'));
    }
  }

  FutureOr<void> _onCycleSaveEventDelete(
      CycleSaveEventDelete event, Emitter<CycleSaveState> emit) async {
    try {
      emit(state.copyWith(status: CycleSaveStateStatus.loading));
      await _cycleRepository.delete(state.cycleModel!.id!);
      emit(state.copyWith(status: CycleSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: CycleSaveStateStatus.error, error: 'Erro ao salvar cycle'));
    }
  }
}
