// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_data_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataTodayEntityAdapter extends TypeAdapter<DataTodayEntity> {
  @override
  final int typeId = 3;

  @override
  DataTodayEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataTodayEntity(
      isCheckIn: fields[0] as bool,
      inventoryIn: fields[1] as DataLocalEntity?,
      inventoryOut: fields[2] as DataLocalEntity?,
      samplingUse: fields[3] as DataLocalEntity?,
      sale: fields[4] as DataLocalEntity?,
      samplingInventory: fields[5] as DataLocalEntity?,
    );
  }

  @override
  void write(BinaryWriter writer, DataTodayEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.isCheckIn)
      ..writeByte(1)
      ..write(obj.inventoryIn)
      ..writeByte(2)
      ..write(obj.inventoryOut)
      ..writeByte(3)
      ..write(obj.samplingUse)
      ..writeByte(4)
      ..write(obj.sale)
      ..writeByte(5)
      ..write(obj.samplingInventory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataTodayEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
