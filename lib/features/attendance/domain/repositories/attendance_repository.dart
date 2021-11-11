import 'package:dartz/dartz.dart';
import 'package:tete2021/features/attendance/domain/entities/attendance_info.dart';
import '../../../../core/error/failure.dart';
import '../../../../features/attendance/domain/entities/attendance_entity.dart';
import '../../../../features/attendance/domain/entities/attendance_status.dart';
import '../../../../features/attendance/domain/entities/attendance_type.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, AttendanceInfo>> checkSP({required AttendanceType type,required String spCode});
  Future<Either<Failure, AttendanceStatus>> checkInOrOut({required AttendanceEntity entity});

}