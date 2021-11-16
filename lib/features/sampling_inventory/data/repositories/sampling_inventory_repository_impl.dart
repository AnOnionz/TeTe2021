import 'package:collection/src/iterable_extensions.dart';
import 'package:dartz/dartz.dart';
import 'package:tete2021/core/utils/dialogs.dart';
import 'package:tete2021/features/login/presentation/blocs/authentication_bloc.dart';
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
    for (var product in samplingInventory.data) {
      product.value = int.parse(product.controller.text);
    }
    if (await networkInfo.isConnected) {
      try {
        final status = await remote.saveSamplingInventory(samplingInventory: samplingInventory);
        samplingInventory.isSync = true;
        await local.cacheSamplingInventory(samplingInventory);
        await dashBoardLocal.cacheDataToday(samplingInventory: samplingInventory);
        return Right(status);
      } on UnAuthenticateException catch (_) {
        await local.cacheSamplingInventory(samplingInventory);
        await dashBoardLocal.cacheDataToday(samplingInventory: samplingInventory);
        return Left(UnAuthenticateFailure());
      } on ResponseException catch (error) {
        await local.cacheSamplingInventory(samplingInventory);
        await dashBoardLocal.cacheDataToday(samplingInventory: samplingInventory);
        return Left(ResponseFailure(message: error.message));
      } on InternalException catch (error) {
        await local.cacheSamplingInventory(samplingInventory);
        await dashBoardLocal.cacheDataToday(samplingInventory: samplingInventory);
        return Left(InternalFailure(message: error.message));
      } on InternetException catch (_) {
        await local.cacheSamplingInventory(samplingInventory);
        await dashBoardLocal.cacheDataToday(samplingInventory: samplingInventory);
        return Left(InternetFailure());
      }catch (error){
        return Left(ResponseFailure(message: error.toString()));
      }
    }
    else {
      await local.cacheSamplingInventory(samplingInventory);
      await dashBoardLocal.cacheDataToday(samplingInventory: samplingInventory);
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
         try{
           await remote.saveSamplingInventory(samplingInventory: sampling);
           sampling.isSync = true;
           await sampling.save();
         }catch(_){}
        }
        return const Right(true);
      }
    }
    return const Right(false);
  }

  @override
  Future<Either<Failure, bool>> saveSamplingInventoryFromUsed({required DataLocalEntity samplingUsed}) async{
    DataLocalEntity? sampling;
    for (var product in samplingUsed.data) {
      product.value = int.parse(product.controller.text);
    }
    final DataLocalEntity? samplingInventory = dashBoardLocal.dataToday.samplingInventory ?? local.fetchSamplingInventory().lastOrNull;
    if(samplingInventory != null){
      final samplingInv = DataLocalEntity(data: List.from(samplingInventory.data), isSync: false);
      samplingInv.data.map((e) {
        final used = samplingUsed.data.firstWhereOrNull((element) => element.id == e.id);
        e.value = (e.value! - used!.value!.toInt());
        return e;
      }).toList();
      sampling = samplingInv;
    }
    if(samplingInventory == null){
      samplingUsed.data.map((e) {
        e.value = (-e.value!);
        return e;
      }).toList();
      sampling = samplingUsed;
    }
    if (await networkInfo.isConnected) {
      try {
        if(sampling !=null){
          await remote.saveSamplingInventory(samplingInventory: sampling);
          sampling.isSync = true;
          await local.cacheSamplingInventory(sampling);
          await dashBoardLocal.cacheDataToday(samplingInventory: sampling);
          if(sampling.data.any((element) => element.value! < AuthenticationBloc.loginEntity!.limit)){
            showMessage(message: "Tồn sampling đang nhỏ hơn mức quy định. Hãy nhập thêm hàng", type: DialogType.box);
          }
        }
        return const Right(true);
      } on UnAuthenticateException catch (_) {
        if(sampling!=null){
          await local.cacheSamplingInventory(sampling);
          await dashBoardLocal.cacheDataToday(samplingInventory: sampling);
        }
        return Left(UnAuthenticateFailure());
      } on ResponseException catch (error) {
        if(sampling!=null){
          await local.cacheSamplingInventory(sampling);
          await dashBoardLocal.cacheDataToday(samplingInventory: sampling);
        }
        return Left(ResponseFailure(message: error.message));
      } on InternalException catch (error) {
        if(sampling!=null){
          await local.cacheSamplingInventory(sampling);
          await dashBoardLocal.cacheDataToday(samplingInventory: sampling);
        }
        return Left(InternalFailure(message: error.message));
      } on InternetException catch (_) {
        if(sampling!=null){
          await local.cacheSamplingInventory(sampling);
          await dashBoardLocal.cacheDataToday(samplingInventory: sampling);
        }
        return Left(InternetFailure());
      }catch (error){
        return Left(ResponseFailure(message: error.toString()));
      }
    }
    else {
      if(sampling != null){
        await local.cacheSamplingInventory(sampling);
        await dashBoardLocal.cacheDataToday(samplingInventory: sampling);
      }
      return Left(FailureAndCachedToLocal("Lưu vào đồng bộ"));
    }
  }

}
