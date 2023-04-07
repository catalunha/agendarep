import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/cycle_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/cycle_repository.dart';
import 'cycle_add_edit_event.dart';
import 'cycle_add_edit_state.dart';

class CycleAddEditBloc extends Bloc<CycleAddEditEvent, CycleAddEditState> {
  final CycleRepository _cycleRepository;
  final UserProfileModel _seller;
  CycleAddEditBloc({
    required CycleModel? cycleModel,
    required CycleRepository cycleRepository,
    required UserProfileModel seller,
  })  : _cycleRepository = cycleRepository,
        _seller = seller,
        super(CycleAddEditState.initial(cycleModel)) {
    on<CycleAddEditEventFormSubmitted>(_onCycleAddEditEventFormSubmitted);
    on<CycleAddEditEventDelete>(_onCycleAddEditEventDelete);
  }

  FutureOr<void> _onCycleAddEditEventFormSubmitted(
      CycleAddEditEventFormSubmitted event,
      Emitter<CycleAddEditState> emit) async {
    emit(state.copyWith(status: CycleAddEditStateStatus.loading));
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
          cycleModel: cycleModel, status: CycleAddEditStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: CycleAddEditStateStatus.error,
          error: 'Erro ao salvar cycle'));
    }
  }

  FutureOr<void> _onCycleAddEditEventDelete(
      CycleAddEditEventDelete event, Emitter<CycleAddEditState> emit) async {
    try {
      emit(state.copyWith(status: CycleAddEditStateStatus.loading));
      await _cycleRepository.delete(state.cycleModel!.id!);
      emit(state.copyWith(status: CycleAddEditStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: CycleAddEditStateStatus.error,
          error: 'Erro ao salvar cycle'));
    }
  }
}
