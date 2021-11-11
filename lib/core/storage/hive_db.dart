import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:tete2021/core/common/keys.dart';
import 'package:tete2021/core/entities/product_entity.dart';
import 'package:tete2021/core/entities/data_local_entity.dart';
import 'package:tete2021/core/platform/date_time.dart';
import 'package:tete2021/features/home/domain/entities/today_data_entity.dart';
import 'package:tete2021/features/login/domain/entities/login_entity.dart';
import 'package:tete2021/features/login/domain/entities/outlet_entity.dart';
import 'package:tete2021/features/login/presentation/blocs/authentication_bloc.dart';

Future<void> init() async {
  var dir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter<DataTodayEntity>(DataTodayEntityAdapter());
  Hive.registerAdapter<ProductEntity>(ProductEntityAdapter());
  Hive.registerAdapter<DataLocalEntity>(DataLocalEntityAdapter());


}
Future<void> initDB(OutletEntity o) async {
  await Hive.openBox<DataTodayEntity>(o.code.toString() + MyDateTime.today + dataDay);
  await Hive.openBox<ProductEntity>(o.code.toString() + productBox);
  await Hive.openBox<DataLocalEntity>(o.code.toString() + inventoryInBox);
  await Hive.openBox<DataLocalEntity>(o.code.toString() + inventoryOutBox);
  await Hive.openBox<DataLocalEntity>(o.code.toString() + samplingUseBox);
  await Hive.openBox<DataLocalEntity>(o.code.toString() + samplingInventoryBox);
}
