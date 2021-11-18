import 'dart:core';

class Geometry {
  String type;
  double latitude;
  double longitude;

  Geometry({
    this.type,
    this.latitude,
    this.longitude,
  });

  Geometry.fromJSON(Map<String, dynamic> data) {
    final List<double> coordinates = data['coordinates'] as List<double>;
    type = data['type'] as String;
    latitude = coordinates[0];
    longitude = coordinates[1];
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = 'Point';
    data['coordinates'] = [latitude, longitude];
    return data;
  }
}
