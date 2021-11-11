part of 'authentication_bloc.dart';

abstract class AuthenticationState  {
  const AuthenticationState();
}
class AuthenticationInitial extends AuthenticationState {}
class AuthenticationLoading extends AuthenticationState {}
class AuthenticationAuthenticated extends AuthenticationState {
  final LoginEntity user;
  AuthenticationAuthenticated({required this.user});
}
class AuthenticationUnauthenticated extends AuthenticationState {

  @override
  String toString() {
    return 'AuthenticationUnauthenticated';
  }
}
class AuthenticationUnSelectOutlet extends AuthenticationState {

  @override
  String toString() {
    return 'AuthenticationUnSelectOutlet';
  }
}
class AuthenticationSelectedOutlet extends AuthenticationState {

  @override
  String toString() {
    return 'AuthenticationSelectedOutlet';
  }
}



