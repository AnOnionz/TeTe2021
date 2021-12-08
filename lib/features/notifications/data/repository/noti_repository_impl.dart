import 'package:dartz/dartz.dart';
import '../../../../core/error/Exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../../../features/notifications/data/datasources/noti_remote_data_source.dart';
import '../../../../features/notifications/domain/entity/noti_entity.dart';
import '../../../../features/notifications/domain/repositories/noti_repository.dart';

class NotifyRepositoryImpl implements NotifyRepository {
  final NetworkInfo networkInfo;
  final NotifyRemoteDataSource remote;

  NotifyRepositoryImpl({required this.networkInfo, required this.remote});

  @override
  Future<Either<Failure, List<NotifyEntity>>> fetchNotify({required int type}) async  {
    try {
      final notifies = await remote.fetchNotify();
      if(type == 1){
        await remote.readAllNotify();
      }
      return Right(notifies);
    } on UnAuthenticateException catch (_) {
      return Left(UnAuthenticateFailure());
    } on ResponseException catch (error) {
      return Left(ResponseFailure(message: error.message));
    } on InternalException catch (error) {
      return Left(InternalFailure(message: error.message));
    } on InternetException catch (_) {
      return Left(InternetFailure());
    } catch (error) {
      return Left(ResponseFailure(message: error.toString()));
    }
  }

}