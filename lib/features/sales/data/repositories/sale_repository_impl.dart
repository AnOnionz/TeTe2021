import 'package:dartz/dartz.dart';
import '../../../../features/sales/data/datasources/sale_local_data_source.dart';
import '../../../../features/sales/data/datasources/sale_use_remote_datasource.dart';
import '../../../../features/sales/domain/repositories/sale_repository.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../core/platform/network_info.dart';
import '../../../../core/error/Exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../features/home/data/datasources/dashboard_local_datasouce.dart';

class SaleRepositoryImpl implements SaleRepository {
  final SaleRemoteDataSource remote;
  final DashBoardLocalDataSource dashBoardLocal;
  final SaleLocalDataSource local;
  final NetworkInfo networkInfo;

  SaleRepositoryImpl(
      {required this.remote, required this.local, required  this.dashBoardLocal, required this.networkInfo,});

  @override
  Future<Either<Failure, bool>> saveSale({required DataLocalEntity sale}) async {
    for (var product in sale.data) {
      product.value = int.parse(product.controller.text);
    }
    if (await networkInfo.isConnected) {
      try {
        await dashBoardLocal.cacheDataToday(sale: sale);
        final status = await remote.saveSale(sale: sale);
        return Right(status);
      } on UnAuthenticateException catch (_) {
        await local.cacheSale(sale);
        return Left(UnAuthenticateFailure());
      } on ResponseException catch (error) {
        await local.cacheSale(sale);
        return Left(ResponseFailure(message: error.message));
      } on InternalException catch (error) {
        await local.cacheSale(sale);
        return Left(InternalFailure(message: error.message));
      } on InternetException catch (_) {
        await local.cacheSale(sale);
        return Left(InternetFailure());
      }catch (error){
        return Left(ResponseFailure(message: error.toString()));
      }
    }
    else {
      await dashBoardLocal.cacheDataToday(sale: sale);
      await local.cacheSale(sale);
      return Left(FailureAndCachedToLocal("Lưu vào đồng bộ"));
    }
  }

  @override
  Future<Either<Failure, bool>> syncSale() async {
    final dataSync = local.fetchSale();
    if (dataSync.isNotEmpty) {
      final nonSync = dataSync.where((element) => element.isSync == false)
          .toList();
      if (nonSync.isEmpty) {
        return const Right(false);
      } else {
        for (DataLocalEntity sale in nonSync) {
         try{
           await remote.saveSale(sale: sale);
           sale.isSync = true;
           await sale.save();
         }catch(_){
           rethrow;
         }
        }
        return const Right(true);
      }
    }
    return const Right(false);
  }

}
