import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';


class LoginPage extends StatelessWidget {

  const LoginPage({Key? key}) : super(key: key);

  Future<String?> _authUser(LoginData data) async {
    throw UnsupportedError('Auth Not implemented yet!');
  }

  Future<String> _recoverPassword(String name) {
    throw UnsupportedError('Recovery Not implemented yet!');
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Desk Booking System',
      userType: LoginUserType.name,
      userValidator: (String? val) => null,
      onLogin: _authUser,
      onSubmitAnimationCompleted: () {
        //todo navigate to home
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
