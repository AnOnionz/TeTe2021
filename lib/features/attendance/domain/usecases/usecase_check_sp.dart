import 'package:dartz/dartz.dart';
import 'package:tete2021/core/error/failure.dart';
import 'package:tete2021/core/usecases/usecase.dart';
import 'package:tete2021/features/attendance/domain/entities/attendance_info.dart';
import 'package:tete2021/features/attendance/domain/entities/attendance_type.dart';
import 'package:tete2021/features/attendance/domain/repositories/attendance_repository.dart';


class UseCaseCheckSP extends UseCase<AttendanceInfo, CheckSPParams> {
  final AttendanceRepository repository;

  UseCaseCheckSP({required this.repository});

  @override
  Future<Either<Failure, AttendanceInfo>> call(CheckSPParams params) async {
    return await repository.checkSP(type: params.type, spCode: params.spCode);
  }
}

class CheckSPParams extends Params{
  final AttendanceType type;
  final String spCode;

  CheckSPParams({required this.type, required this.spCode});
}
