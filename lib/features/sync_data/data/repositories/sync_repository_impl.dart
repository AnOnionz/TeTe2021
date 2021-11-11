import 'package:dartz/dartz.dart';
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



   SyncRepositoryImpl({required this.inventoryRepository, required this.networkInfo,required this.local,required this.dashBoardLocalDataSource});


   @override
   Future<Either<Failure, SyncEntity>> synchronous() async {
     if (await networkInfo.isConnected) {
       try {
         await inventoryRepository.syncInventoryIn();
         await inventoryRepository.syncInventoryOut();
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
       }catch (error){
         return Left(ResponseFailure(message: error.toString()));
       }
     } else {
       return Left(InternetFailure());
     }
   }

 }
