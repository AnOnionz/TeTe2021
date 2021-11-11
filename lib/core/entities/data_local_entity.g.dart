// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_local_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataLocalEntityAdapter extends TypeAdapter<DataLocalEntity> {
  @override
  final int typeId = 5;

  @override
  DataLocalEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataLocalEntity(
      data: (fields[0] as List).cast<ProductEntity>(),
      isSync: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DataLocalEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.isSync);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataLocalEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
