import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../features/sync_data/domain/entities/sync_entity.dart';

 abstract class SyncRepository{
   Future<Either<Failure, SyncEntity>> synchronous();
 }