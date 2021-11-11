import 'package:hive/hive.dart';
import '../../../../core/common/keys.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../features/login/presentation/blocs/authentication_bloc.dart';
import '../../../../features/sync_data/domain/entities/sync_entity.dart';


abstract class InventoryLocalDataSource {
  Future<void> cacheInventoryIn(DataLocalEntity inventory);
  Future<void> cacheInventoryOut(DataLocalEntity inventory);
  List<DataLocalEntity> fetchInventoryIn();
  List<DataLocalEntity> fetchInventoryOut();
  bool getSyncIn();
  bool getSyncOut();

}
class InventoryLocalDataSourceImpl implements InventoryLocalDataSource{

  InventoryLocalDataSourceImpl();

  @override
  Future<void> cacheInventoryIn(DataLocalEntity inventory) async {
    Box<DataLocalEntity> box = Hive.box(AuthenticationBloc.loginEntity!.id.toString() + inventoryInBox);
    final inventories = box.values.toList();
    if(inventories.isNotEmpty){
      for (var element in inventories) {
        // xoa du lieu chua dong bo cu
        if(!element.isSync) await element.delete();
      }
    }
    await box.add(inventory);
  }

  @override
  Future<void> cacheInventoryOut(DataLocalEntity inventory) async {
    Box<DataLocalEntity> box = Hive.box(AuthenticationBloc.loginEntity!.id.toString() + inventoryOutBox);
    final inventories = box.values.toList();
    if(inventories.isNotEmpty){
      for (var element in inventories) {
        // xoa du lieu chua dong bo cu
        if(!element.isSync) await element.delete();
      }
    }
    await box.add(inventory);
  }

  @override
  List<DataLocalEntity> fetchInventoryIn() {
    Box<DataLocalEntity> box = Hive.box(AuthenticationBloc.loginEntity!.id.toString() + inventoryInBox);
    return box.values.toList();
  }

  @override
  List<DataLocalEntity> fetchInventoryOut() {
    Box<DataLocalEntity> box = Hive.box(AuthenticationBloc.loginEntity!.id.toString() + inventoryOutBox);
    return box.values.toList();
  }

  @override
  bool getSyncIn() {
    final inventory = fetchInventoryIn();
    if(inventory.isNotEmpty){
      for (var element in inventory) {
        if(element.isSync == false){
          return true;
        }
      }
    }
    return false;
  }


  @override
  bool getSyncOut() {
    final inventory = fetchInventoryOut();
    if(inventory.isNotEmpty){
      for (var element in inventory) {
        if(element.isSync == false){
          return true;
        }

      }
    }
    return false;
  }
}