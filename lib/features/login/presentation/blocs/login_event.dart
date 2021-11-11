part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {
  const LoginEvent();
}
class Login extends LoginEvent {
  final String userName;
  final String password;

  const Login({required this.userName,required this.password});
}
class Logout extends LoginEvent {}
