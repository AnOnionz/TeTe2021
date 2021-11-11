import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_unsafe.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../core/platform/network_info.dart';
import '../../../../features/inventory/data/datasources/inventory_local_data_source.dart';
import '../../../../features/inventory/data/datasources/inventory_remote_datasource.dart';
import '../../../../features/inventory/domain/repositories/inventory_repository.dart';
import '../../../../core/error/Exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../features/home/data/datasources/dashboard_local_datasouce.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource remote;
  final DashBoardLocalDataSource dashBoardLocal;
  final InventoryLocalDataSource local;
  final NetworkInfo networkInfo;

  InventoryRepositoryImpl(
      {required this.remote, required this.local, required  this.dashBoardLocal, required this.networkInfo,});

  @override
  Future<Either<Failure, bool>> saveInventoryIn({required DataLocalEntity inventory}) async {
    if (await networkInfo.isConnected) {
      try {
        final status = await remote.saveInventory();
        for (var product in inventory.data) {
          product.value = int.parse(product.controller.text);
        }
        await local.cacheInventoryIn(inventory);
        await dashBoardLocal.cacheDataToday(inventoryIn: inventory);
        return Right(status);
      } on UnAuthenticateException catch (_) {
        await local.cacheInventoryOut(inventory);
        return Left(UnAuthenticateFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on InternalException catch (error) {
        return Left(InternalFailure(message: error.message));
      } on InternetException catch (_) {
        await local.cacheInventoryIn(inventory);
        return Left(InternetFailure());
      }catch (error){
        return Left(ResponseFailure(message: error.toString()));
      }
    }
    else {
      await local.cacheInventoryIn(inventory);
      return Left(FailureAndCachedToLocal("Lưu vào đồng bộ"));
    }
  }

  @override
  Future<Either<Failure, bool>> saveInventoryOut({required DataLocalEntity inventory}) async {
    if (await networkInfo.isConnected) {
      try {
        final status = await remote.saveInventory();
        for (var product in inventory.data) {
          product.value = int.parse(product.controller.text);
        }
        await local.cacheInventoryOut(inventory);
        await dashBoardLocal.cacheDataToday(inventoryOut: inventory);
        return Right(status);
      } on UnAuthenticateException catch (_) {
        await local.cacheInventoryOut(inventory);
        return Left(UnAuthenticateFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on InternalException catch (error) {
        return Left(InternalFailure(message: error.message));
      } on InternetException catch (_) {
        await local.cacheInventoryOut(inventory);
        return Left(InternetFailure());
      } catch (error){
        return Left(ResponseFailure(message: error.toString()));
      }
    }
    else {
      await local.cacheInventoryOut(inventory);
      return Left(FailureAndCachedToLocal("Lưu vào đồng bộ"));
    }
  }

  @override
  Future<Either<Failure, bool>> syncInventoryIn() async {
    final dataSync = local.fetchInventoryIn();
    if (dataSync.isNotEmpty) {
      final nonSync = dataSync.where((element) => element.isSync == false)
          .toList();
      if (nonSync.isEmpty) {
        return const Right(false);
      } else {
        for (DataLocalEntity inv in nonSync) {
          await remote.saveInventory();
          inv.isSync = true;
          await inv.save();
        }
        return const Right(true);
      }
    }
    return const Right(false);
  }

  @override
  Future<Either<Failure, bool>> syncInventoryOut() async {
    final dataSync = local.fetchInventoryOut();
    if (dataSync.isNotEmpty) {
      final nonSync = dataSync.where((element) => element.isSync == false)
          .toList();
      if (nonSync.isEmpty) {
        return const Right(false);
      } else {
        for (DataLocalEntity inv in nonSync) {
          await remote.saveInventory();
          inv.isSync = true;
          await inv.save();
        }
        return const Right(true);
      }
    }
    return const Right(false);
  }
}
