// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/pointProperties.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PointPropertiesAdapter extends TypeAdapter<PointProperties> {
  @override
  final int typeId = 3;

  @override
  PointProperties read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PointProperties(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
      altitude: fields[2] as double,
      consumption: fields[3] as double,
      co2: fields[4] as double,
      speed: fields[5] as double,
      maf: fields[6] as double,
      time: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PointProperties obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.altitude)
      ..writeByte(3)
      ..write(obj.consumption)
      ..writeByte(4)
      ..write(obj.co2)
      ..writeByte(5)
      ..write(obj.speed)
      ..writeByte(6)
      ..write(obj.maf)
      ..writeByte(7)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PointPropertiesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
