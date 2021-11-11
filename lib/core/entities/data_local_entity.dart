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
      "data": data,
      'isSync': isSync,
    };
  }

  @override
  String toString() {
    return 'DataLocalEntity{ data: $data, isSync: $isSync}';
  }
}