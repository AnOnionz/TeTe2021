import 'package:dartz/dartz.dart';
import 'package:tete2021/features/attendance/domain/entities/attendance_info.dart';
import '../../../../core/error/Exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../features/attendance/data/datasources/attendance_remote_datasource.dart';
import '../../../../features/attendance/domain/entities/attendance_entity.dart';
import '../../../../features/attendance/domain/entities/attendance_status.dart';
import '../../../../features/attendance/domain/entities/attendance_type.dart';
import '../../../../features/attendance/domain/repositories/attendance_repository.dart';
import '../../../../features/home/data/datasources/dashboard_local_datasouce.dart';
import '../../../../features/login/presentation/blocs/authentication_bloc.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remote;
  final DashBoardLocalDataSource dashBoardLocalDataSource;
  AttendanceRepositoryImpl({required this.remote, required this.dashBoardLocalDataSource});

  @override
  Future<Either<Failure, AttendanceStatus>> checkInOrOut(
      {required AttendanceEntity entity}) async {

    try {
      final response = await remote.checkInOrOut(
          entity: entity);
      if(entity.type is CheckIn){
        dashBoardLocalDataSource.cacheDataToday(checkIn: true);
      }
      if(entity.type is CheckOut){
        dashBoardLocalDataSource.cacheDataToday(checkIn: false);
      }
      return Right(response);
    } on UnAuthenticateException catch (_) {
      return Left(UnAuthenticateFailure());
    } on ResponseException catch (error) {
      return Left(ResponseFailure(message: error.message));
    } on InternalException catch (error) {
      return Left(InternalFailure(message: error.message));
    } on InternetException catch (_) {
      return Left(InternetFailure());
    } catch (error){
      return Left(ResponseFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, AttendanceInfo>> checkSP({required AttendanceType type,required String spCode}) async {

    try {
      final response = await remote.checkSP(type: type, spCode: spCode);
      return Right(response);
    } on UnAuthenticateException catch (_) {
      return Left(UnAuthenticateFailure());
    } on ResponseException catch (error) {
      return Left(ResponseFailure(message: error.message));
    } on InternalException catch (error) {
      return Left(InternalFailure(message: error.message));
    } on InternetException catch (_) {
      return Left(InternetFailure());
    } catch (error){
      return Left(ResponseFailure(message: error.toString()));
    }
  }

}
