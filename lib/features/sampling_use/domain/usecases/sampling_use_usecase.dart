import 'package:dartz/dartz.dart';
import 'package:tete2021/features/home/domain/entities/features.dart';
import 'package:tete2021/features/sampling_inventory/domain/repositories/sampling_inventory_repository.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../features/sampling_use/domain/repositories/sampling_use_repository.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';

class SamplingUseUseCase extends UseCase<bool, SamplingUseParam> {
  final SamplingUseRepository repository;
  final SamplingInventoryRepository samplingInventoryRepository;

  SamplingUseUseCase({required this.repository, required this.samplingInventoryRepository});
  @override
  Future<Either<Failure, bool>> call(SamplingUseParam params) async {
   await repository.saveSamplingUse(samplingUse: params.samplingUse);
   return await samplingInventoryRepository.saveSamplingInventoryFromUsed(samplingUsed: params.samplingUse);

  }
}

class SamplingUseParam extends Params {
  final DataLocalEntity samplingUse;
  SamplingUseParam({required this.samplingUse}): super();

  @override
  List<Object> get props => [];
}
