
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../features/sync_data/domain/entities/sync_entity.dart';
import '../../../../features/sync_data/domain/repositories/sync_repository.dart';


 class SyncUseCase extends UseCase<SyncEntity, NoParams>{
   final SyncRepository repository;

   SyncUseCase({required this.repository});
   @override
   Future<Either<Failure, SyncEntity>> call(NoParams params) async {
    return await repository.synchronous();
   }

 }