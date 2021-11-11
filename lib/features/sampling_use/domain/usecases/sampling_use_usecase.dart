import 'package:dartz/dartz.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../features/sampling_use/domain/repositories/sampling_use_repository.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';

class SamplingUseUseCase extends UseCase<bool, SamplingUseParam> {
  final SamplingUseRepository repository;

  SamplingUseUseCase({required this.repository});
  @override
  Future<Either<Failure, bool>> call(SamplingUseParam params) async {
    return await repository.saveSamplingUse(samplingUse: params.samplingUse);
  }
}

class SamplingUseParam extends Params {
  final DataLocalEntity samplingUse;
  SamplingUseParam({required this.samplingUse}): super();

  @override
  List<Object> get props => [];
}
