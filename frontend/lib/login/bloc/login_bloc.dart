import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:frontend/app/repositories/authentication_repository.dart';
import 'package:frontend/login/models/password.dart';
import 'package:frontend/login/models/username.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required this.authenticationRepository,
  })  : super(const LoginState()) {
    on<LoginUsernameChanged>(
            (event, emit) => emit(_mapUsernameChangedToState(event, state)),);
    on<LoginPasswordChanged>(
            (event, emit) => emit(_mapPasswordChangedToState(event, state)),);
    on<LoginSubmitted>((event, emit) async =>
    await _mapLoginSubmittedToState(event, state, emit),);
  }

  final AuthenticationRepository authenticationRepository;


  LoginState _mapUsernameChangedToState(
      LoginUsernameChanged event,
      LoginState state,
      ) {
    final username = Username.dirty(event.username);
    return state.copyWith(
      username: username,
      status: Formz.validate([state.password, username]),
    );
  }

  LoginState _mapPasswordChangedToState(
      LoginPasswordChanged event,
      LoginState state,
      ) {
    final password = Password.dirty(event.password);
    return state.copyWith(
      password: password,
      status: Formz.validate([password, state.username]),
    );
  }

  Future<void> _mapLoginSubmittedToState(
      LoginSubmitted event,
      LoginState state,
      Emitter<LoginState> emit,
      ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      try {
        await authenticationRepository.login(variables: <String, dynamic>{
          'username': state.username.value,
          'password': state.password.value,
        },);
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } on Exception catch (_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
