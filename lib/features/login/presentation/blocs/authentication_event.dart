part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {
  const AuthenticationEvent();

}
class SetOutlet extends AuthenticationEvent {
  final OutletEntity outlet;

  SetOutlet({required this.outlet});
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
class SelectOutlet extends AuthenticationEvent {
  final OutletEntity outletEntity;

  SelectOutlet({required this.outletEntity});
  @override
  String toString() => 'SelectOutlet';
}
class ChangeOutlet extends AuthenticationEvent {
  @override
  String toString() => 'ChangeOutlet';
}