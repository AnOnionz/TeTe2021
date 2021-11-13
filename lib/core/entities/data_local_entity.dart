import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tete2021/core/common/keys.dart';
import 'package:tete2021/core/entities/product_entity.dart';
part 'data_local_entity.g.dart';

@HiveType(typeId: syncId)
class DataLocalEntity extends HiveObject{
  @HiveField(0)
  final List<ProductEntity> data;
  @HiveField(1)
  bool isSync;

  DataLocalEntity({required this.data, required this.isSync});

  Map<String, dynamic> toJson(){
    return {
      'isSync': isSync,
      "data": data,
    };
  }

  @override
  String toString() {
    return 'DataLocalEntity{ isSync: $isSync,  data: ${data.map((e) => e.value)},}';
  }
}