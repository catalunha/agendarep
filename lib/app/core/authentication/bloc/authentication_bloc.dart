import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../data/b4a/b4a_exception.dart';
import '../../../data/b4a/init_back4app.dart';
import '../../models/user_model.dart';
import '../../repositories/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState>
    with ChangeNotifier {
  final UserRepository _userRepository;
  AuthenticationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    // on<_AuthenticationEventStatusChanged>(_onAuthenticationEventStatusChanged);
    on<AuthenticationEventInitial>(_onAuthenticationEventInitial);
    on<AuthenticationEventLoginRequested>(_onAuthenticationEventLoginRequested);
    on<AuthenticationEventLogoutRequested>(
      _onAuthenticationEventLogoutRequested,
    );
    on<AuthenticationEventUpdateUserProfile>(
      _onAuthenticationEventUpdateUserProfile,
    );
  }

  FutureOr<void> _onAuthenticationEventLogoutRequested(
    AuthenticationEventLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final bool logout = await _userRepository.logout();
      if (logout) {
        emit(const AuthenticationState.unauthenticated());
      }
      emit(const AuthenticationState.unauthenticated());
      notifyListeners();
    } catch (_) {
      emit(const AuthenticationState.unauthenticated());
    }
  }

  FutureOr<void> _onAuthenticationEventLoginRequested(
    AuthenticationEventLoginRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    print('onAuthenticationEventReceiveUser');
    emit(AuthenticationState.authenticated(event.user));
    notifyListeners();
  }

  FutureOr<void> _onAuthenticationEventInitial(
    AuthenticationEventInitial event,
    Emitter<AuthenticationState> emit,
  ) async {
    log('+++ AuthenticationEventInitial');
    final InitBack4app initBack4app = InitBack4app();
    try {
      final bool initParse = await initBack4app.init();
      log('+++ AuthenticationEventInitial 1');
      if (initParse) {
        log('+++ AuthenticationEventInitial 2');
        final user = await _userRepository.hasUserLogged();
        log('+++ AuthenticationEventInitial 3');
        if (user != null) {
          log('+++ AuthenticationEventInitial 4');
          if (user.userProfile?.isActive == true) {
            log('+++ AuthenticationEventInitial 5');
            emit(AuthenticationState.authenticated(user));
            log('Já logado ${user.email}');
            notifyListeners();
          } else {
            log('+++ AuthenticationEventInitial 7');

            emit(
              state.copyWith(
                status: AuthenticationStatus.unauthenticated,
                error:
                    'Sua conta ainda esta em análise. Tente login mais tarde.',
              ),
            );
            add(AuthenticationEventLogoutRequested());
          }
        } else {
          log('+++ AuthenticationEventInitial 6');

          emit(
            state.copyWith(
              status: AuthenticationStatus.unauthenticated,
              error: 'Faça login novamente.',
            ),
          );
        }
      }
      notifyListeners();
    } on B4aException catch (e) {
      print('+++ _onAuthenticationEventInitial');
      print(e);
      emit(
        state.copyWith(
          status: AuthenticationStatus.databaseError,
          error: e.toString(),
        ),
      );
    } catch (e) {
      print('+++ _onAuthenticationEventInitial');
      print(e);
      emit(
        state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          error: 'Erro desconhecido na inicialização',
        ),
      );
    }
  }

  FutureOr<void> _onAuthenticationEventUpdateUserProfile(
    AuthenticationEventUpdateUserProfile event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(state.copyWith(user: event.user));
  }
}
