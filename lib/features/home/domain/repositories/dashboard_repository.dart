
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../features/login/domain/entities/outlet_entity.dart';

abstract class DashboardRepository {
  Future<void> saveDataToday();
  Future<void> saveProductFromServer();

}

