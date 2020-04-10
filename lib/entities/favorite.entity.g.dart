// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteEntityAdapter extends TypeAdapter<FavoriteEntity> {
  @override
  final typeId = 0;

  @override
  FavoriteEntity read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteEntity(
      symbol: fields[0] as String,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.symbol)
      ..writeByte(1)
      ..write(obj.name);
  }
}
