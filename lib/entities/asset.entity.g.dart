// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssetEntityAdapter extends TypeAdapter<AssetEntity> {
  @override
  final typeId = 2;

  @override
  AssetEntity read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssetEntity(
      symbol: fields[0] as String,
      name: fields[1] as String,
      amount: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, AssetEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.symbol)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.amount);
  }
}
