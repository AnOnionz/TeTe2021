import 'package:dartz/dartz.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../features/sampling_inventory/domain/repositories/sampling_inventory_repository.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';

class SamplingInventoryUseCase extends UseCase<bool, SamplingInventoryParam> {
  final SamplingInventoryRepository repository;

  SamplingInventoryUseCase({required this.repository});
  @override
  Future<Either<Failure, bool>> call(SamplingInventoryParam params) async {
    return await repository.saveSamplingInventory(samplingInventory: params.samplingInventory);
  }
}

class SamplingInventoryParam extends Params {
  final DataLocalEntity samplingInventory;
  SamplingInventoryParam({required this.samplingInventory}): super();

  @override
  List<Object> get props => [];
}
