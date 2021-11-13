import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:tete2021/core/entities/product_entity.dart';
import 'package:tete2021/core/error/Exception.dart';
import 'package:tete2021/core/error/failure.dart';
import 'package:tete2021/core/platform/network_info.dart';
import 'package:tete2021/features/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:tete2021/features/attendance/domain/entities/attendance_type.dart';
import 'package:tete2021/features/home/data/datasources/dashboard_local_datasouce.dart';
import 'package:tete2021/features/home/data/datasources/dashboard_remote_datasource.dart';
import 'package:tete2021/features/home/domain/repositories/dashboard_repository.dart';
import 'package:tete2021/features/login/domain/entities/outlet_entity.dart';
import 'package:tete2021/features/login/presentation/blocs/authentication_bloc.dart';


class DashboardRepositoryImpl implements DashboardRepository {
  final AttendanceRemoteDataSource attendanceRemoteDataSource;
  final DashBoardRemoteDataSource remote;
  final DashBoardLocalDataSource local;
  final NetworkInfo networkInfo;

  DashboardRepositoryImpl({required this.networkInfo, required this.local, required this.remote, required this.attendanceRemoteDataSource, });


  @override
  Future<void> saveProductFromServer() async {
    final products = await remote.fetchProduct();
    await local.cacheProducts(products: products);
  }
  @override
  Future<void> saveDataToday() async {
    final dataToday = await remote.fetchDetail();
    local.cacheDataToday(checkIn: dataToday.isCheckIn, inventoryIn: dataToday.inventoryIn, inventoryOut: dataToday.inventoryOut, samplingUse: dataToday.samplingUse, samplingInventory: dataToday.samplingInventory, sale: dataToday.sale);
    print(dataToday);
  }
}


