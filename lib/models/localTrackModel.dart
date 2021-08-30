import 'package:hive/hive.dart';

import '../constants.dart';
import 'pointProperties.dart';
import 'car.dart';

part '../hive_generated_models/localTrackModel.g.dart';

@HiveType(typeId: kLocalTrackTypeId)
class LocalTrackModel {
  @HiveField(0)
  final String trackId;
  @HiveField(1)
  final String trackName;
  @HiveField(2)
  final DateTime startTime;
  @HiveField(3)
  final DateTime endTime;
  @HiveField(4)
  final String duration;
  @HiveField(5)
  final double distance;
  @HiveField(6)
  final double speed;
  @HiveField(7)
  final String selectedCarId;
  @HiveField(8)
  final bool isTrackUploaded;
  @HiveField(9)
  final int stops;
  @HiveField(10)
  final String bluetoothDevice;
  @HiveField(11)
  final Map<int, PointProperties> properties;
  @HiveField(12)
  final String carManufacturer;
  @HiveField(13)
  final String carFuelType;
  @HiveField(14)
  final String carModel;
  @HiveField(15)
  final int carConstructionYear;
  @HiveField(16)
  final int carEngineDisplacement;

  LocalTrackModel({
    this.trackId,
    this.trackName,
    this.startTime,
    this.endTime,
    this.duration,
    this.distance,
    this.speed,
    this.selectedCarId,
    this.isTrackUploaded,
    this.stops,
    this.bluetoothDevice,
    this.properties,
    this.carManufacturer,
    this.carFuelType,
    this.carModel,
    this.carConstructionYear,
    this.carEngineDisplacement
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocalTrackModel &&
        runtimeType == other.runtimeType &&
        trackId == other.trackId &&
        trackName == other.trackName &&
        startTime == other.startTime &&
        endTime == other.endTime &&
        duration == other.duration &&
        distance == other.distance &&
        speed == other.speed &&
        selectedCarId == other.selectedCarId &&
        isTrackUploaded == other.isTrackUploaded &&
        stops == other.stops &&
        bluetoothDevice == other.bluetoothDevice &&
        properties == other.properties &&
        carManufacturer == other.carManufacturer &&
        carModel == other.carModel &&
        carFuelType == other.carFuelType &&
        carEngineDisplacement == other.carEngineDisplacement &&
        carConstructionYear == other.carConstructionYear;
  }

  @override
  int get hashCode {
    return trackId.hashCode ^
    trackName.hashCode ^
    startTime.hashCode ^
    endTime.hashCode ^
    duration.hashCode ^
    distance.hashCode ^
    speed.hashCode ^
    selectedCarId.hashCode ^
    isTrackUploaded.hashCode ^
    stops.hashCode ^
    bluetoothDevice.hashCode ^
    properties.hashCode ^
    carConstructionYear.hashCode ^
    carEngineDisplacement.hashCode ^
    carFuelType.hashCode ^
    carManufacturer.hashCode ^
    carModel.hashCode;
  }

  /// function to return [trackId] of the [track]
  String get getTrackId => trackId;

  /// function to return [distance] covered during the [track]
  double get getDistance => distance;

  /// function to return [startTime] of the [track]
  DateTime get getStartTime => startTime;

  /// function to return [endTime] of the [track]
  DateTime get getEndTime => endTime;

  /// function to return selected [carId]
  String get getCarId => selectedCarId;

  /// function to get [trackName] of the [track]
  String get getTrackName => trackName;

  /// function to return [properties] of the [track]
  Map<int, PointProperties> get getProperties => properties;

  /// function to get [sensor properties]
  Properties get getCarProperties {
    final Properties properties = Properties(
        engineDisplacement: carEngineDisplacement,
        manufacturer: carManufacturer,
        constructionYear: carConstructionYear,
        model: carModel,
        fuelType: carFuelType,
        id: selectedCarId
    );

    return properties;
  }

}