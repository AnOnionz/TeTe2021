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
  Future<Either<Failure, OutletEntity>> fetchOutlet({required String code}) async {
    if (await networkInfo.isConnected) {
      try {
        final outlet = await remote.findOutlet(code: code);
        return Right(outlet);
      } on InternetException catch (_) {
        return Left(InternetFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on UnAuthenticateException catch (_) {
        return Left(UnAuthenticateFailure());
      } on InternalException catch (error) {
        return Left(InternalFailure(message: error.message));
      } catch (error) {
        return Left(ResponseFailure(message: error.toString()));
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<void> saveProductFromServer() async {
   try{
     //final products = await remote.fetchProduct();
     final products = [ProductEntity(index :1, name: "A", image: "https://product.hstatic.net/1000115147/product/snack-ca-_cp_724fd3ec01674bd99712f04b1678b03a_master.png"), ProductEntity(index: 2, name: "B", image: "https://product.hstatic.net/1000115147/product/snack-ca-_cp_724fd3ec01674bd99712f04b1678b03a_master.png"), ProductEntity(index :3, name: "C", image: "https://product.hstatic.net/1000115147/product/snack-ca-_cp_724fd3ec01674bd99712f04b1678b03a_master.png")];
     await local.cacheProducts(products: products);
   // ignore: empty_catches
   }catch(e) {

   }
  }
  @override
  Future<void> saveAttendanceStatus() async {
    try {
      final status = await attendanceRemoteDataSource.checkStatus(outletCode: AuthenticationBloc.outletEntity!.code);
      if(status is CheckIn){
        await local.cacheDataToday(checkIn: true);
      }if(status is CheckOut){
        await local.cacheDataToday(checkIn: false);
      }
    // ignore: empty_catches
    }catch(e) {
    }

  }
}


