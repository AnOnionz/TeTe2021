import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../features/home/data/datasources/dashboard_local_datasouce.dart';
import '../../../../features/login/domain/entities/login_entity.dart';
import '../../../../features/login/domain/usecases/login_usecase.dart';
import '../../../../features/login/domain/usecases/logout_usecase.dart';
import 'authentication_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase login;
  final LogoutUseCase logout;
  final AuthenticationBloc authenticationBloc;
  final DashBoardLocalDataSource local;
  LoginBloc({
    required this.login,
    required this.logout,
    required this.authenticationBloc,
    required this.local,
  })  : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if(event is Login){
        yield LoginLoading();
        final _login = await login(LoginParams(username: event.userName, password: event.password));
        yield _login.fold((failure){
          displayError(failure);
          return LoginFailure(message: failure.message);
          }, (success) {
          authenticationBloc.add(LoggedIn(loginEntity: success));
          return LoginSuccess(user: success);
        });
    }
    if (event is Logout) {
      yield LogoutLoading();
      final _logout = await logout(NoParams());
      yield _logout.fold((failure){
        displayError(failure);
        return LogoutFailure(message: failure.message);
      }, (success) {
        authenticationBloc.add(LoggedOut());
        return LogoutSuccess();});

    }
  }
}



