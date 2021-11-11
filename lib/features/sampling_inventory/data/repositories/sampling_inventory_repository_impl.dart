import 'package:dartz/dartz.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../core/platform/network_info.dart';
import '../../../../features/sampling_inventory/data/datasources/sampling_inventory_local_data_source.dart';
import '../../../../features/sampling_inventory/data/datasources/sampling_inventory_remote_datasource.dart';
import '../../../../features/sampling_inventory/domain/repositories/sampling_inventory_repository.dart';
import '../../../../core/error/Exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../features/home/data/datasources/dashboard_local_datasouce.dart';

class SamplingInventoryRepositoryImpl implements SamplingInventoryRepository {
  final SamplingInventoryRemoteDataSource remote;
  final DashBoardLocalDataSource dashBoardLocal;
  final SamplingInventoryLocalDataSource local;
  final NetworkInfo networkInfo;

  SamplingInventoryRepositoryImpl(
      {required this.remote, required this.local, required  this.dashBoardLocal, required this.networkInfo,});

  @override
  Future<Either<Failure, bool>> saveSamplingInventory({required DataLocalEntity samplingInventory}) async {
    if (await networkInfo.isConnected) {
      try {
        final status = await remote.saveSamplingInventory();
        for (var product in samplingInventory.data) {
          product.value = int.parse(product.controller.text);
        }
        local.cacheSamplingInventory(samplingInventory);
        dashBoardLocal.cacheDataToday(samplingInventory: samplingInventory);
        return Right(status);
      } on UnAuthenticateException catch (_) {
        await local.cacheSamplingInventory(samplingInventory);
        return Left(UnAuthenticateFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on InternalException catch (error) {
        return Left(InternalFailure(message: error.message));
      } on InternetException catch (_) {
        await local.cacheSamplingInventory(samplingInventory);
        return Left(InternetFailure());
      }catch (error){
        return Left(ResponseFailure(message: error.toString()));
      }
    }
    else {
      await local.cacheSamplingInventory(samplingInventory);
      return Left(FailureAndCachedToLocal("Lưu vào đồng bộ"));
    }
  }

  @override
  Future<Either<Failure, bool>> syncSamplingInventory() async {
    final dataSync = local.fetchSamplingInventory();
    if (dataSync.isNotEmpty) {
      final nonSync = dataSync.where((element) => element.isSync == false)
          .toList();
      if (nonSync.isEmpty) {
        return const Right(false);
      } else {
        for (DataLocalEntity sampling in nonSync) {
          await remote.saveSamplingInventory();
          sampling.isSync = true;
          await sampling.save();
        }
        return const Right(true);
      }
    }
    return const Right(false);
  }

}
