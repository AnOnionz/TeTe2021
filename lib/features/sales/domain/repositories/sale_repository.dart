import 'package:dartz/dartz.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../core/error/failure.dart';

abstract class SaleRepository {
  Future<Either<Failure, bool>> saveSale({required DataLocalEntity sale});
  Future<Either<Failure, bool>> syncSale();
}