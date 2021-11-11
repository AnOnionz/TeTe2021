import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tete2021/features/home/presentation/blocs/dashboard_bloc.dart';
import '../../../../core/api/myDio.dart';
import '../../../../core/common/keys.dart';
import '../../../../features/home/data/datasources/dashboard_local_datasouce.dart';
import '../../../../features/login/data/model/login_model.dart';
import '../../../../features/login/domain/entities/login_entity.dart';
import '../../../../features/login/domain/entities/outlet_entity.dart';
import '../../../../core/storage/hive_db.dart' as hive;

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final DashBoardLocalDataSource local;
  final FlutterSecureStorage storage;
  static LoginEntity? loginEntity;
  static OutletEntity? outletEntity;
  AuthenticationBloc({required this.storage, required this.local}) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      try {
        String? loginEntity = await storage.read(key: user);
        if (loginEntity != null) {
          add(LoggedIn(loginEntity: LoginModel.fromJson(jsonDecode(loginEntity))));
        } else {
          yield AuthenticationUnauthenticated();
        }
      } catch (e) {
        print("can't read user in storage");
        yield AuthenticationUnauthenticated();
      }
    }
    if (event is LoggedIn) {
      yield AuthenticationLoading();
      loginEntity = event.loginEntity;
      await storage.write(key: user, value: jsonEncode(loginEntity!.toJson()));
      Modular.get<CDio>().setBearerAuth(token: loginEntity!.token);
      yield AuthenticationUnSelectOutlet();
    }
    if (event is SelectOutlet) {
      await hive.initDB(event.outletEntity);
      AuthenticationBloc.outletEntity = event.outletEntity;
      yield AuthenticationSelectedOutlet();
    }
    if(event is ChangeOutlet){
      AuthenticationBloc.outletEntity = null;
      yield AuthenticationUnSelectOutlet();
    }
    if (event is LoggedOut) {
      await storage.delete(key: user);
      yield AuthenticationUnauthenticated();
    }
  }
}
