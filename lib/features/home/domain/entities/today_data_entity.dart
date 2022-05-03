import 'package:hive/hive.dart';
import '../../../../core/common/keys.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../core/entities/product_entity.dart';
part 'today_data_entity.g.dart';

@HiveType(typeId: dataTodayId)

class DataTodayEntity extends HiveObject {
  @HiveField(0)
  bool isCheckIn;
  @HiveField(1)
  DataLocalEntity? inventoryIn;
  @HiveField(2)
  DataLocalEntity? inventoryOut;
  @HiveField(3)
  DataLocalEntity? samplingUse;
  @HiveField(4)
  DataLocalEntity? sale;
  @HiveField(5)
  DataLocalEntity? samplingInventory;


  DataTodayEntity(
      {required this.isCheckIn, this.inventoryIn, this.inventoryOut, this.samplingUse, this.sale, this.samplingInventory});

  factory DataTodayEntity.fromJson(Map<String, dynamic> json){
    return DataTodayEntity(
      isCheckIn: json['checkInOut'] != null ? json['checkInOut']['time_out'] != null ? false : true : false,
      inventoryIn: json['begin'] != null ? DataLocalEntity(isSync: true, data: (json['begin']['data'] as List).map((e) => ProductEntity.fromDetail(e)).toList()) : null,
      inventoryOut: json['end'] != null ? DataLocalEntity(isSync: true, data: (json['end']['data'] as List).map((e) => ProductEntity.fromDetail(e)).toList()) : null,
      samplingUse:json['used'] != null ? DataLocalEntity(isSync: true, data: (json['used']['data'] as List).map((e) => ProductEntity.fromDetail(e)).toList()) : null,
      samplingInventory: json['sampling'] != null ? DataLocalEntity(isSync: true, data: (json['sampling']['data'] as List).map((e) => ProductEntity.fromDetail(e)).toList()) : null,
      sale: json['otv'] != null ? DataLocalEntity(isSync: true, data: (json['otv']['data'] as List).map((e) => ProductEntity.fromDetail(e)).toList()) : null,
    );
  }

  @override
  String toString() {
    return 'DataTodayEntity{isCheckIn: $isCheckIn, inventoryIn: $inventoryIn, inventoryOut: $inventoryOut, samplingUse: $samplingUse, sale: $sale, samplingInventory: $samplingInventory}';
  }
}