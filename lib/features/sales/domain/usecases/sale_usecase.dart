import 'package:dartz/dartz.dart';
import 'package:tete2021/features/sales/domain/repositories/sale_repository.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../features/sampling_use/domain/repositories/sampling_use_repository.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';

class SaleUseCase extends UseCase<bool, SaleParam> {
  final SaleRepository repository;

  SaleUseCase({required this.repository});
  @override
  Future<Either<Failure, bool>> call(SaleParam params) async {
    return await repository.saveSale(sale: params.sale);
  }
}

class SaleParam extends Params {
  final DataLocalEntity sale;
  SaleParam({required this.sale}): super();

  @override
  List<Object> get props => [];
}
