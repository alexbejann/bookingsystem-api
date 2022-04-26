import 'dart:async';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    yield* _controller.stream;
  }

  Future<void> logInWithEmailAndPassword({
    required String username,
    required String password,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 250),
          () => _controller.add(
          _login(username: username, password: password)
              ? AuthenticationStatus.authenticated
              : AuthenticationStatus.unauthenticated,),
    );
  }

  bool _login({String? username, String? password}) {
    return username == 'alex' && password == 'admin123';
  }

  void logOut() => _controller.add(AuthenticationStatus.unauthenticated);

  void dispose() => _controller.close();
}