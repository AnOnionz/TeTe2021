import 'package:hive/hive.dart';
import '../../../../core/common/keys.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../features/login/presentation/blocs/authentication_bloc.dart';
import '../../../../features/sync_data/domain/entities/sync_entity.dart';


abstract class SaleLocalDataSource {
  Future<void> cacheSale(DataLocalEntity sale);
  List<DataLocalEntity> fetchSale();
  bool getSync();

}
class SaleLocalDataSourceImpl implements SaleLocalDataSource{
  SaleLocalDataSourceImpl();

  @override
  Future<void> cacheSale(DataLocalEntity sale) async {
    Box<DataLocalEntity> box = Hive.box(AuthenticationBloc.loginEntity!.id.toString() + saleBox);
    final sales = box.values.toList();
    if(sales.isNotEmpty){
      for (var element in sales) {
        // xoa du lieu chua dong bo cu
        if(!element.isSync) await element.delete();
      }
    }
    await box.add(sale);
  }

  @override
  List<DataLocalEntity> fetchSale() {
    Box<DataLocalEntity> box = Hive.box(AuthenticationBloc.loginEntity!.id.toString() + saleBox);
    return box.values.toList();
  }

  @override
  bool getSync() {
    final sales = fetchSale();
    if(sales.isNotEmpty){
      for (var element in sales) {
        if(element.isSync == false){
          return true;
        }
      }
    }
    return false;
  }

}