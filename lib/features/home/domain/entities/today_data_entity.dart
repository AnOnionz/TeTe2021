import 'package:hive/hive.dart';
import 'package:tete2021/core/common/keys.dart';
import 'package:tete2021/core/entities/data_local_entity.dart';
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
  DataLocalEntity? samplingInventory;

  DataTodayEntity(
      {required this.isCheckIn, this.inventoryIn, this.inventoryOut, this.samplingUse, this.samplingInventory});

  factory DataTodayEntity.fromJson(Map<String, dynamic> json){
    return DataTodayEntity(
      isCheckIn: json['checkIn'],
      inventoryIn: json['inventoryIn'],
      inventoryOut: json['inventoryOut'],
      samplingUse: json['samplingUse'],
      samplingInventory: json['samplingInventory'],
    );
  }
  Map<String, dynamic> toJson(){
    return {
      "checkIn": isCheckIn,
      "inventoryIn": inventoryIn,
      "inventoryOut": inventoryOut,
      "samplingUse": samplingUse,
      "samplingInventory": samplingInventory,
    };
  }

  @override
  String toString() {
    return 'DataTodayEntity{isCheckIn: $isCheckIn, inventoryIn: $inventoryIn, inventoryOut: $inventoryOut, samplingUse: $samplingUse, samplingInventory: $samplingInventory}';
  }
}