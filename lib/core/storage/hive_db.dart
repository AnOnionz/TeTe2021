import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../../../../core/common/keys.dart';
import '../../../../core/entities/product_entity.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../core/platform/date_time.dart';
import '../../../../features/home/domain/entities/today_data_entity.dart';
import '../../../../features/login/domain/entities/login_entity.dart';
import '../../../../features/login/domain/entities/outlet_entity.dart';
import '../../../../features/login/presentation/blocs/authentication_bloc.dart';

Future<void> init() async {
  var dir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter<DataTodayEntity>(DataTodayEntityAdapter());
  Hive.registerAdapter<ProductEntity>(ProductEntityAdapter());
  Hive.registerAdapter<DataLocalEntity>(DataLocalEntityAdapter());

}
Future<void> initDB(LoginEntity o) async {
  await Hive.openBox<DataTodayEntity>(o.id.toString() + MyDateTime.today + dataDay);
  await Hive.openBox<ProductEntity>(o.id.toString() + productBox);
  await Hive.openBox<DataLocalEntity>(o.id.toString() + inventoryInBox);
  await Hive.openBox<DataLocalEntity>(o.id.toString() + inventoryOutBox);
  await Hive.openBox<DataLocalEntity>(o.id.toString() + samplingUseBox);
  await Hive.openBox<DataLocalEntity>(o.id.toString() + samplingInventoryBox);
  await Hive.openBox<DataLocalEntity>(o.id.toString() + saleBox);
}
