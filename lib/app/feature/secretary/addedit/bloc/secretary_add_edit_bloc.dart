import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/secretary_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/secretary_repository.dart';
import 'secretary_add_edit_event.dart';
import 'secretary_add_edit_state.dart';

class SecretaryAddEditBloc
    extends Bloc<SecretaryAddEditEvent, SecretaryAddEditState> {
  final SecretaryRepository _secretaryRepository;
  final UserProfileModel _seller;
  SecretaryAddEditBloc({
    required SecretaryModel? secretaryModel,
    required SecretaryRepository secretaryRepository,
    required UserProfileModel seller,
  })  : _secretaryRepository = secretaryRepository,
        _seller = seller,
        super(SecretaryAddEditState.initial(secretaryModel)) {
    on<SecretaryAddEditEventFormSubmitted>(
        _onSecretaryAddEditEventFormSubmitted);
    on<SecretaryAddEditEventDelete>(_onSecretaryAddEditEventDelete);
  }

  FutureOr<void> _onSecretaryAddEditEventFormSubmitted(
      SecretaryAddEditEventFormSubmitted event,
      Emitter<SecretaryAddEditState> emit) async {
    emit(state.copyWith(status: SecretaryAddEditStateStatus.loading));
    try {
      SecretaryModel secretaryModel;
      if (state.secretaryModel == null) {
        secretaryModel = SecretaryModel(
          seller: _seller,
          email: event.email,
          name: event.name,
          phone: event.phone,
          birthday: event.birthday,
          description: event.description,
        );
      } else {
        secretaryModel = state.secretaryModel!.copyWith(
          email: event.email,
          name: event.name,
          phone: event.phone,
          birthday: event.birthday,
          description: event.description,
        );
      }
      String secretaryModelId =
          await _secretaryRepository.update(secretaryModel);

      secretaryModel = secretaryModel.copyWith(id: secretaryModelId);

      emit(state.copyWith(
          secretaryModel: secretaryModel,
          status: SecretaryAddEditStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: SecretaryAddEditStateStatus.error,
          error: 'Erro ao salvar secretary'));
    }
  }

  FutureOr<void> _onSecretaryAddEditEventDelete(
      SecretaryAddEditEventDelete event,
      Emitter<SecretaryAddEditState> emit) async {
    try {
      emit(state.copyWith(status: SecretaryAddEditStateStatus.loading));
      await _secretaryRepository.delete(state.secretaryModel!.id!);
      emit(state.copyWith(status: SecretaryAddEditStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: SecretaryAddEditStateStatus.error,
          error: 'Erro ao salvar secretary'));
    }
  }
}
