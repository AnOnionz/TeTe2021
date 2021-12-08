import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/entities/product_entity.dart';
import '../../../../core/error/Exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../../../features/attendance/data/datasources/attendance_remote_datasource.dart';
import '../../../../features/attendance/domain/entities/attendance_type.dart';
import '../../../../features/home/data/datasources/dashboard_local_datasouce.dart';
import '../../../../features/home/data/datasources/dashboard_remote_datasource.dart';
import '../../../../features/home/domain/repositories/dashboard_repository.dart';
import '../../../../features/login/domain/entities/outlet_entity.dart';
import '../../../../features/login/presentation/blocs/authentication_bloc.dart';


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


