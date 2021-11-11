import 'package:dartz/dartz.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../features/inventory/domain/repositories/inventory_repository.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';

class InventoryInUseCase extends UseCase<bool, InventoryParam> {
  final InventoryRepository repository;

  InventoryInUseCase({required this.repository});
  @override
  Future<Either<Failure, bool>> call(InventoryParam params) async {
    return await repository.saveInventoryIn(inventory: params.inventory);
  }
}

class InventoryParam extends Params {
final DataLocalEntity inventory;
  InventoryParam({required this.inventory}): super();

  @override
  List<Object> get props => [];
}
