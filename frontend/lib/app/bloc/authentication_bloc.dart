import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/app/model/user.dart';
import 'package:frontend/app/repositories/authentication_repository.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required this.authenticationRepository,
  })  : assert(authenticationRepository != null,
            'AuthenticationRepository never null',),

        super(
          const AuthenticationState.unknown(),
        ) {
    _authenticationStatusSubscription = authenticationRepository.status.listen(
      (status) => add(
        AuthenticationStatusChanged(status),
      ),
    );
    on<AuthenticationStatusChanged>(
      (event, emit) async =>
          emit(await _mapAuthenticationStatusChangedtoState(event)),
    );
    on<AuthenticationUserChanged>(
      (event, emit) => emit(_mapAuthenticationUserChangedToState(event)),
    );
    on<AuthenticationLogoutRequested>(
      (event, emit) => authenticationRepository.logOut(),
    );
  }
  final AuthenticationRepository authenticationRepository;

  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  bool isAuthenticated() => state.status == AuthenticationStatus.authenticated;

  void logout() =>
      add(const AuthenticationStatusChanged(AuthenticationStatus.unauthenticated));

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    authenticationRepository.dispose();
    return super.close();
  }

  Future<AuthenticationState> _mapAuthenticationStatusChangedtoState(
    AuthenticationStatusChanged event,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return const AuthenticationState.unauthenticated();
      case AuthenticationStatus.authenticated:
        final user = await _tryGetUser();
        return user != null
            ? AuthenticationState.authenticated(user)
            : const AuthenticationState.unauthenticated();
      default:
        return const AuthenticationState.unknown();
    }
  }

  AuthenticationState _mapAuthenticationUserChangedToState(
          AuthenticationUserChanged event) =>
      event.user != User.empty
          ? AuthenticationState.authenticated(event.user)
          : const AuthenticationState.unauthenticated();

  Future<User?> _tryGetUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('userAccount')) {
        return null;
      }
      final prefString = prefs.getString('user');
      final extractedUserData =
          jsonDecode(prefString.toString()) as Map<String, dynamic>;
      return User.fromJson(extractedUserData);
    } on Exception {
      return null;
    }
  }

  // AuthenticationState fromJson(Map<String, dynamic> json) =>
  //     AuthenticationState._(
  //       status: AuthenticationStatus.values[json['status']],
  //       user: User.fromJson(json['user']),
  //     );

  // Map<String, dynamic> toJson(AuthenticationState state) =>
  //     {'status': state.status.index, 'user': state.user.toJson()};
}
