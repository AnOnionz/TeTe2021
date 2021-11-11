part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}
class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginFailure extends LoginState {
  final String message;

  LoginFailure({required this.message});
  @override
  List<Object> get props => [message];
}
class LoginSuccess extends LoginState {
  final LoginEntity user;

  LoginSuccess({required this.user});
}
class LogoutLoading extends LoginState {}
class LogoutFailure extends LoginState {
  final String message;

  LogoutFailure({required this.message});
  @override
  List<Object> get props => [message];
}
class LogoutSuccess extends LoginState {
}

