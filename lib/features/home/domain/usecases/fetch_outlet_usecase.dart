import 'package:dartz/dartz.dart';
import 'package:tete2021/core/error/failure.dart';
import 'package:tete2021/core/usecases/usecase.dart';
import 'package:tete2021/features/home/domain/repositories/dashboard_repository.dart';
import 'package:tete2021/features/login/domain/entities/outlet_entity.dart';

class FetchOutletUseCase implements UseCase<OutletEntity, FetchOutletParams>{
  final DashboardRepository repository;

  FetchOutletUseCase({required this.repository});


  @override
  Future<Either<Failure, OutletEntity>> call(FetchOutletParams params) async {
    return await repository.fetchOutlet(code: params.code);
  }
}
class FetchOutletParams extends Params {
  final String code;

  FetchOutletParams({required this.code});

}