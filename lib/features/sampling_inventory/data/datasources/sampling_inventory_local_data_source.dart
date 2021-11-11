import 'package:hive/hive.dart';
import '../../../../core/common/keys.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../features/login/presentation/blocs/authentication_bloc.dart';
import '../../../../features/sync_data/domain/entities/sync_entity.dart';


abstract class SamplingInventoryLocalDataSource {
  Future<void> cacheSamplingInventory(DataLocalEntity samplingInventory);
  List<DataLocalEntity> fetchSamplingInventory();
  bool getSync();

}
class SamplingInventoryLocalDataSourceImpl implements SamplingInventoryLocalDataSource{

  SamplingInventoryLocalDataSourceImpl();

  @override
  Future<void> cacheSamplingInventory(DataLocalEntity samplingInventory) async {
    Box<DataLocalEntity> box = Hive.box(AuthenticationBloc.loginEntity!.id.toString() + samplingInventoryBox);
    final samplingInventories = box.values.toList();
    if(samplingInventories.isNotEmpty){
      for (var element in samplingInventories) {
        // xoa du lieu chua dong bo cu
        if(!element.isSync) await element.delete();
      }
    }
    await box.add(samplingInventory);
  }

  @override
  List<DataLocalEntity> fetchSamplingInventory() {
    Box<DataLocalEntity> box = Hive.box(AuthenticationBloc.loginEntity!.id.toString() + samplingInventoryBox);
    return box.values.toList();
  }

  @override
  bool getSync() {
    final samplingInventory = fetchSamplingInventory();
    if(samplingInventory.isNotEmpty){
      for (var element in samplingInventory) {
        if(element.isSync == false){
          return true;
        }
      }
    }
    return false;
  }

}