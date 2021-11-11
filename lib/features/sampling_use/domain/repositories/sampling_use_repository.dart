import 'package:dartz/dartz.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../core/error/failure.dart';

abstract class SamplingUseRepository {
  Future<Either<Failure, bool>> saveSamplingUse({required DataLocalEntity samplingUse});
  Future<Either<Failure, bool>> syncSamplingUse();
}