import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../features/attendance/domain/entities/attendance_entity.dart';
import '../../../../features/attendance/domain/entities/attendance_status.dart';
import '../../../../features/attendance/domain/repositories/attendance_repository.dart';

class UseCaseCheckInOrOut extends UseCase<AttendanceStatus, CheckInOrOutParam> {
  final AttendanceRepository repository;

  UseCaseCheckInOrOut({required this.repository});
  @override
  Future<Either<Failure, AttendanceStatus>> call(CheckInOrOutParam params) async {
    return await repository.checkInOrOut(entity: params.entity);
  }
}

class CheckInOrOutParam extends Params {
 final AttendanceEntity entity;

  CheckInOrOutParam({required this.entity}): super();

  @override
  List<Object> get props => [entity];
}
