
import 'package:dartz/dartz.dart';
import 'package:tete2021/core/error/failure.dart';
import 'package:tete2021/features/login/domain/entities/outlet_entity.dart';

abstract class DashboardRepository {
  Future<void> saveDataToday();
  Future<void> saveProductFromServer();

}

