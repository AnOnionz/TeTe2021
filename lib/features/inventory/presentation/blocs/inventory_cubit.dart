import 'package:bloc/bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meta/meta.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../core/entities/product_entity.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../features/inventory/domain/usecases/inventory_in_usecase.dart';
import '../../../../features/inventory/domain/usecases/inventory_out_usecase.dart';
import '../../../../features/inventory/presentation/screens/inventory_page.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final InventoryInUseCase inventoryIn;
  final InventoryOutUseCase inventoryOut;
  InventoryCubit({
    required this.inventoryIn,
    required this.inventoryOut,
  }) : super(InventoryInitial());

  void updateInventory(InventoryType type, List<ProductEntity> products) async {
    emit(InventoryLoading());
    final inventory = DataLocalEntity(
        data: products,
        isSync: false);
    final execute = type == InventoryType.start
        ? await inventoryIn(InventoryParam(inventory: inventory))
        : await inventoryOut(InventoryParam(inventory: inventory));
    emit(execute.fold((l) {
      displayError(l);
      return InventoryFailure();
    }, (r) {
      displaySuccess(message: "Lưu thành công");
      return InventorySuccess();
    }));
  }
}
