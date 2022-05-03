import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meta/meta.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../features/attendance/domain/entities/attendance_type.dart';
import '../../../../features/attendance/domain/usecases/usecase_check_sp.dart';
import '../../../../features/home/data/datasources/dashboard_local_datasouce.dart';
import '../../../../features/home/domain/usecases/save_to_local_usecase.dart';
import '../../../../features/login/presentation/blocs/authentication_bloc.dart';
import '../../../../core/storage/hive_db.dart' as hive;

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final SaveDataToLocalUseCase saveDataToLocal;
  final AuthenticationBloc authenticationBloc;
  final UseCaseCheckSP checkStatus;
  final DashBoardLocalDataSource local;

  DashboardBloc(
      {required this.authenticationBloc,
      required this.local,
      required this.checkStatus,
       required this.saveDataToLocal,
      })
      : super(DashboardInitial());

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if(event is RefreshDashboard){
      yield DashboardRefresh();
    }
    if (event is SaveServerDataToLocalData) {
      yield DashboardSaving();
      final result = await saveDataToLocal(NoParams());
      yield result.fold((failure) {
        return DashboardFailure(failure: failure);
      }, (r) {
        return DashboardSaved();});
    }
  }
}
