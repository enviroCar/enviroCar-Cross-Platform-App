import 'package:hive/hive.dart';

import '../constants.dart';
import 'pointProperties.dart';

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
    this.properties
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
        properties == other.properties;
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
        properties.hashCode;
  }


  @override
  String toString() {
    return 'LocalTrackModel{trackId: $trackId, trackName: $trackName, startTime: $startTime, endTime: $endTime, duration: $duration, distance: $distance, speed: $speed, selectedCarId: $selectedCarId, isTrackUploaded: $isTrackUploaded, stops: $stops, bluetoothDevice: $bluetoothDevice, properties: $properties}';
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

}