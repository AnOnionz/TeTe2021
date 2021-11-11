import 'package:dartz/dartz.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../core/error/failure.dart';

abstract class SamplingInventoryRepository {
  Future<Either<Failure, bool>> saveSamplingInventory({required DataLocalEntity samplingInventory});
  Future<Either<Failure, bool>> syncSamplingInventory();
}