import 'package:dartz/dartz.dart';
import '../../../../features/sales/domain/repositories/sale_repository.dart';
import '../../../../features/sampling_inventory/domain/repositories/sampling_inventory_repository.dart';
import '../../../../features/sampling_use/domain/repositories/sampling_use_repository.dart';
import '../../../../core/error/Exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../../../features/home/data/datasources/dashboard_local_datasouce.dart';
import '../../../../features/inventory/domain/repositories/inventory_repository.dart';
import '../../../../features/sync_data/data/datasources/sync_local_data_source.dart';
import '../../../../features/sync_data/domain/entities/sync_entity.dart';
import '../../../../features/sync_data/domain/repositories/sync_repository.dart';

class SyncRepositoryImpl implements SyncRepository {
  final NetworkInfo networkInfo;
  final DashBoardLocalDataSource dashBoardLocalDataSource;
  final SyncLocalDataSource local;
  final InventoryRepository inventoryRepository;
  final SamplingInventoryRepository samplingInventoryRepository;
  final SamplingUseRepository samplingUseRepository;
  final SaleRepository saleRepository;

  SyncRepositoryImpl({
    required this.inventoryRepository,
    required this.networkInfo,
    required this.local,
    required this.dashBoardLocalDataSource,
    required this.samplingInventoryRepository,
    required this.samplingUseRepository,
    required this.saleRepository,
  });

  @override
  Future<Either<Failure, SyncEntity>> synchronous() async {
    Exception? exception;
    final tasks = [
      samplingInventoryRepository.syncSamplingInventory(),
      inventoryRepository.syncInventoryIn(),
      samplingUseRepository.syncSamplingUse(),
      inventoryRepository.syncInventoryOut(),
      saleRepository.syncSale(),
    ];
    if (await networkInfo.isConnected) {
      for (var task in tasks) {
        try {
          await task;
        } catch (e) {
          exception = exception ?? e as Exception?;
        }
      }
      if (exception != null) {
        if (exception is InternetException) {
          return Left(InternetFailure());
        }
        if (exception is UnAuthenticateException) {
          return Left(UnAuthenticateFailure());
        }
        if (exception is InternalException) {
          return Left(InternalFailure(message: exception.message));
        } else {
          return Left(ResponseFailure(message: exception.toString()));
        }
      } else {
        final sync = local.getSync();
        return Right(sync);
      }
    } else {
      return Left(InternetFailure());
    }

    if (await networkInfo.isConnected) {
      try {
        await samplingInventoryRepository.syncSamplingInventory();
        await inventoryRepository.syncInventoryIn();
        await samplingUseRepository.syncSamplingUse();
        await inventoryRepository.syncInventoryOut();
        await saleRepository.syncSale();
        final sync = local.getSync();
        return Right(sync);
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
    } else {
      return Left(InternetFailure());
    }
  }
}
