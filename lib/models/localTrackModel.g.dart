// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localTrackModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalTrackModelAdapter extends TypeAdapter<LocalTrackModel> {
  @override
  final int typeId = 2;

  @override
  LocalTrackModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalTrackModel(
      trackId: fields[0] as String,
      trackName: fields[1] as String,
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime,
      duration: fields[4] as String,
      distance: fields[5] as double,
      speed: fields[6] as double,
      selectedCarId: fields[7] as String,
      isTrackUploaded: fields[8] as bool,
      stops: fields[9] as int,
      bluetoothDevice: fields[10] as String,
      properties: (fields[11] as Map)?.cast<int, PointProperties>(),
      carManufacturer: fields[12] as String,
      carFuelType: fields[13] as String,
      carModel: fields[14] as String,
      carConstructionYear: fields[15] as int,
      carEngineDisplacement: fields[16] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LocalTrackModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.trackId)
      ..writeByte(1)
      ..write(obj.trackName)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.distance)
      ..writeByte(6)
      ..write(obj.speed)
      ..writeByte(7)
      ..write(obj.selectedCarId)
      ..writeByte(8)
      ..write(obj.isTrackUploaded)
      ..writeByte(9)
      ..write(obj.stops)
      ..writeByte(10)
      ..write(obj.bluetoothDevice)
      ..writeByte(11)
      ..write(obj.properties)
      ..writeByte(12)
      ..write(obj.carManufacturer)
      ..writeByte(13)
      ..write(obj.carFuelType)
      ..writeByte(14)
      ..write(obj.carModel)
      ..writeByte(15)
      ..write(obj.carConstructionYear)
      ..writeByte(16)
      ..write(obj.carEngineDisplacement);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalTrackModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
