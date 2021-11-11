
import 'package:dartz/dartz.dart';
import 'package:tete2021/core/error/failure.dart';
import 'package:tete2021/features/login/domain/entities/outlet_entity.dart';

abstract class DashboardRepository {
  Future<void> saveAttendanceStatus();
  Future<void> saveProductFromServer();
  Future<Either<Failure, OutletEntity>> fetchOutlet({required String code});

}

