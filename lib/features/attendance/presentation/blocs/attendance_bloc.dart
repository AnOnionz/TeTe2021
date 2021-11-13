import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:tete2021/core/common/constants.dart';
import 'package:tete2021/features/attendance/domain/entities/attendance_info.dart';
import 'package:tete2021/features/login/presentation/blocs/authentication_bloc.dart';
import 'package:tete2021/features/sync_data/data/datasources/sync_local_data_source.dart';
import 'package:tete2021/features/sync_data/domain/repositories/sync_repository.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../features/attendance/domain/entities/attendance_entity.dart';
import '../../../../features/attendance/domain/entities/attendance_status.dart';
import '../../../../features/attendance/domain/entities/attendance_type.dart';
import '../../../../features/attendance/domain/usecases/usecase_check_inout.dart';
import '../../../../features/attendance/domain/usecases/usecase_check_sp.dart';
import '../../../../features/home/data/datasources/dashboard_local_datasouce.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class CheckAttendanceBloc extends Bloc<AttendanceEvent, CheckAttendanceState> {
  final UseCaseCheckSP useCaseCheckSP;
  final DashBoardLocalDataSource dashBoardLocalDataSource;
  final SyncLocalDataSource syncLocal;

  CheckAttendanceBloc({
    required this.dashBoardLocalDataSource,
    required this.useCaseCheckSP,
    required this.syncLocal
  }) : super(CheckAttendanceInitial());

  @override
  Stream<CheckAttendanceState> mapEventToState(AttendanceEvent event) async* {
    if (event is CheckAttendance) {
      yield CheckAttendanceLoading();
      if(event.type is CheckOut){
        final dataToday = dashBoardLocalDataSource.dataToday;
        if(dataToday.inventoryIn == null){
          showMessage(message: InventoryInNullFailure().message, type: DialogType.shock);
          yield CheckAttendanceFailure();
          return;
        }
        if(dataToday.inventoryOut == null){
          showMessage(message: InventoryOutNullFailure().message, type: DialogType.shock);
          yield CheckAttendanceFailure();
          return;
        }
        if(dataToday.sale == null){
          showMessage(message: SaleNullFailure().message, type: DialogType.shock);
          yield CheckAttendanceFailure();
          return;
        }
        if(dataToday.samplingUse == null){
          showMessage(message: SamplingUseNullFailure().message, type: DialogType.shock);
          yield CheckAttendanceFailure();
          return;
        }
        if(syncLocal.hasDataNonSync){
          showMessage(message: HasSyncFailure().message, type: DialogType.shock);
          yield CheckAttendanceFailure();
          return;
        }
      }
      final checkSPResponse = await useCaseCheckSP(CheckSPParams(type: event.type, spCode: event.spCode));
      yield* _eitherCheckAttendanceState(checkSPResponse);
    }
  }
}

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final UseCaseCheckInOrOut useCaseCheckInOrOut;

  AttendanceBloc({required this.useCaseCheckInOrOut})
      : super(AttendanceInitial());

  @override
  Stream<AttendanceState> mapEventToState(
    AttendanceEvent event,
  ) async* {
    if (event is Attendance) {
      yield AttendanceLoading();
      final checkInOrOutResponse = await useCaseCheckInOrOut(
          CheckInOrOutParam(entity: AttendanceEntity(spCode: event.spCode, type: event.type, image: event.img, position: event.position)));
      yield* _eitherAttendanceState(
          checkInOrOutResponse);
    }
  }
}

Stream<CheckAttendanceState> _eitherCheckAttendanceState(
    Either<Failure, AttendanceInfo> either) async* {
  yield either.fold((failure) {
    displayError(failure);
    return CheckAttendanceFailure();
  }, (info) {
    return CheckAttendanceSuccess(info: info);
  });
}

Stream<AttendanceState> _eitherAttendanceState(
    Either<Failure, AttendanceStatus> either) async* {
  yield either.fold((failure) {
    displayError(failure);
    return AttendanceFailure();
  }, (status) {
    displaySuccess(message: "Chấm công thành công");
    Modular.to.pop(true);
    return AttendanceSuccess();
  });
}
