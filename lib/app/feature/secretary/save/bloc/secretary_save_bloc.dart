import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/secretary_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/secretary_repository.dart';
import 'secretary_save_event.dart';
import 'secretary_save_state.dart';

class SecretarySaveBloc extends Bloc<SecretarySaveEvent, SecretarySaveState> {
  final SecretaryRepository _secretaryRepository;
  final UserProfileModel _seller;
  SecretarySaveBloc({
    required SecretaryModel? model,
    required SecretaryRepository secretaryRepository,
    required UserProfileModel seller,
  })  : _secretaryRepository = secretaryRepository,
        _seller = seller,
        super(SecretarySaveState.initial(model)) {
    on<SecretarySaveEventFormSubmitted>(_onSecretarySaveEventFormSubmitted);
    on<SecretarySaveEventDelete>(_onSecretarySaveEventDelete);
  }

  FutureOr<void> _onSecretarySaveEventFormSubmitted(
      SecretarySaveEventFormSubmitted event,
      Emitter<SecretarySaveState> emit) async {
    emit(state.copyWith(status: SecretarySaveStateStatus.loading));
    try {
      SecretaryModel secretaryModel;
      if (state.model == null) {
        secretaryModel = SecretaryModel(
          seller: _seller,
          email: event.email,
          name: event.name,
          phone: event.phone,
          birthday: event.birthday,
        );
      } else {
        secretaryModel = state.model!.copyWith(
          email: event.email,
          name: event.name,
          phone: event.phone,
          birthday: event.birthday,
        );
      }
      final String secretaryModelId =
          await _secretaryRepository.update(secretaryModel);

      secretaryModel = secretaryModel.copyWith(id: secretaryModelId);

      emit(state.copyWith(
          model: secretaryModel, status: SecretarySaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: SecretarySaveStateStatus.error,
          error: 'Erro ao salvar secretary'));
    }
  }

  FutureOr<void> _onSecretarySaveEventDelete(
      SecretarySaveEventDelete event, Emitter<SecretarySaveState> emit) async {
    try {
      emit(state.copyWith(status: SecretarySaveStateStatus.loading));
      await _secretaryRepository.delete(state.model!.id!);
      emit(state.copyWith(status: SecretarySaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: SecretarySaveStateStatus.error,
          error: 'Erro ao salvar secretary'));
    }
  }
}
