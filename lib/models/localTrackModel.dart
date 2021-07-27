import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocalTrackModel {
  String trackId;
  String trackName;
  DateTime modifiedTime;
  DateTime endTime;
  Duration duration;
  double distance;
  double speed;
  String selectedCarId; // or Car selectedCar
  bool isTrackUploaded;
  int stops;
  BluetoothDevice bluetoothDevice;
  Map<LatLng, Map<String, dynamic>> dataAtCoordinates;

  LocalTrackModel({
    this.trackId,
    this.trackName,
    this.modifiedTime,
    this.endTime,
    this.duration,
    this.distance,
    this.speed,
    this.selectedCarId,
    this.isTrackUploaded,
    this.stops,
    this.bluetoothDevice,
    this.dataAtCoordinates
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocalTrackModel &&
        runtimeType == other.runtimeType &&
        trackId == other.trackId &&
        trackName == other.trackName &&
        modifiedTime == other.modifiedTime &&
        endTime == other.endTime &&
        duration == other.duration &&
        distance == other.distance &&
        speed == other.speed &&
        selectedCarId == other.selectedCarId &&
        isTrackUploaded == other.isTrackUploaded &&
        stops == other.stops &&
        bluetoothDevice == other.bluetoothDevice &&
        dataAtCoordinates == other.dataAtCoordinates;
  }

  @override
  int get hashCode {
    return trackId.hashCode ^
        trackName.hashCode ^
        modifiedTime.hashCode ^
        endTime.hashCode ^
        duration.hashCode ^
        distance.hashCode ^
        speed.hashCode ^
        selectedCarId.hashCode ^
        isTrackUploaded.hashCode ^
        stops.hashCode ^
        bluetoothDevice.hashCode ^
        dataAtCoordinates.hashCode;
  }

}