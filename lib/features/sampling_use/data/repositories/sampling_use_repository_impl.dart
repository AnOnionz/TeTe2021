import 'package:dartz/dartz.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../core/platform/network_info.dart';
import '../../../../features/sampling_use/data/datasources/sampling_local_data_source.dart';
import '../../../../features/sampling_use/data/datasources/sampling_use_remote_datasource.dart';
import '../../../../features/sampling_use/domain/repositories/sampling_use_repository.dart';
import '../../../../core/error/Exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../features/home/data/datasources/dashboard_local_datasouce.dart';

class SamplingUseRepositoryImpl implements SamplingUseRepository {
  final SamplingUseRemoteDataSource remote;
  final DashBoardLocalDataSource dashBoardLocal;
  final SamplingUseLocalDataSource local;
  final NetworkInfo networkInfo;

  SamplingUseRepositoryImpl(
      {required this.remote, required this.local, required  this.dashBoardLocal, required this.networkInfo,});

  @override
  Future<Either<Failure, bool>> saveSamplingUse({required DataLocalEntity samplingUse}) async {
    if (await networkInfo.isConnected) {
      try {
        final status = await remote.saveSamplingUse();
        for (var product in samplingUse.data) {
          product.value = int.parse(product.controller.text);
        }
        local.cacheSamplingUse(samplingUse);
        dashBoardLocal.cacheDataToday(samplingUse: samplingUse);
        return Right(status);
      } on UnAuthenticateException catch (_) {
        await local.cacheSamplingUse(samplingUse);
        return Left(UnAuthenticateFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on InternalException catch (error) {
        return Left(InternalFailure(message: error.message));
      } on InternetException catch (_) {
        await local.cacheSamplingUse(samplingUse);
        return Left(InternetFailure());
      }catch (error){
        return Left(ResponseFailure(message: error.toString()));
      }
    }
    else {
      await local.cacheSamplingUse(samplingUse);
      return Left(FailureAndCachedToLocal("Lưu vào đồng bộ"));
    }
  }

  @override
  Future<Either<Failure, bool>> syncSamplingUse() async {
    final dataSync = local.fetchSamplingUse();
    if (dataSync.isNotEmpty) {
      final nonSync = dataSync.where((element) => element.isSync == false)
          .toList();
      if (nonSync.isEmpty) {
        return const Right(false);
      } else {
        for (DataLocalEntity sampling in nonSync) {
          await remote.saveSamplingUse();
          sampling.isSync = true;
          await sampling.save();
        }
        return const Right(true);
      }
    }
    return const Right(false);
  }

}
