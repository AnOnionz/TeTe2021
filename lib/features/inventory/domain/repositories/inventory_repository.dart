import 'package:dartz/dartz.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../core/error/failure.dart';

abstract class InventoryRepository {
  Future<Either<Failure, bool>> saveInventoryIn({required DataLocalEntity inventory});
  Future<Either<Failure, bool>> syncInventoryIn();
  Future<Either<Failure, bool>> saveInventoryOut({required DataLocalEntity inventory});
  Future<Either<Failure, bool>> syncInventoryOut();
}