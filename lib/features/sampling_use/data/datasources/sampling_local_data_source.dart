import 'package:hive/hive.dart';
import '../../../../core/common/keys.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../features/login/presentation/blocs/authentication_bloc.dart';
import '../../../../features/sync_data/domain/entities/sync_entity.dart';


abstract class SamplingUseLocalDataSource {
  Future<void> cacheSamplingUse(DataLocalEntity samplingUse);
  List<DataLocalEntity> fetchSamplingUse();
  bool getSync();

}
class SamplingUseLocalDataSourceImpl implements SamplingUseLocalDataSource{
  SamplingUseLocalDataSourceImpl();

  @override
  Future<void> cacheSamplingUse(DataLocalEntity samplingUse) async {
    Box<DataLocalEntity> box = Hive.box(AuthenticationBloc.loginEntity!.id.toString() + samplingUseBox);
    final samplingUses = box.values.toList();
    if(samplingUses.isNotEmpty){
      for (var element in samplingUses) {
        // xoa du lieu chua dong bo cu
        if(!element.isSync) await element.delete();
      }
    }
    await box.add(samplingUse);
  }

  @override
  List<DataLocalEntity> fetchSamplingUse() {
    Box<DataLocalEntity> box = Hive.box(AuthenticationBloc.loginEntity!.id.toString() + samplingUseBox);
    return box.values.toList();
  }

  @override
  bool getSync() {
    final samplingUse = fetchSamplingUse();
    if(samplingUse.isNotEmpty){
      for (var element in samplingUse) {
        if(element.isSync == false){
          return true;
        }
      }
    }
    return false;
  }

}