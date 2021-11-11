import 'package:dartz/dartz.dart';
import '../../../../features/inventory/domain/repositories/inventory_repository.dart';
import '../../../../features/inventory/domain/usecases/inventory_in_usecase.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';

class InventoryOutUseCase extends UseCase<bool, InventoryParam> {
  final InventoryRepository repository;

  InventoryOutUseCase({required this.repository});
  @override
  Future<Either<Failure, bool>> call(InventoryParam params) async {
    return await repository.saveInventoryOut(inventory: params.inventory);
  }
}

