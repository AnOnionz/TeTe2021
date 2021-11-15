part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {
  const AuthenticationEvent();

}
class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthenticationEvent {
  final LoginEntity loginEntity;

  LoggedIn({required this.loginEntity});

  @override
  String toString() => 'LoggedIn { outlet: $loginEntity.}';
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}