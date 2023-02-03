import 'geometry.dart';
import 'phenomenons.dart';

class Feature {
  String? type;
  Geometry? geometry;
  String? time;
  Phenomenons? phenomenons;
  String? sensorId;

  Feature({
    this.type,
    this.geometry,
    this.time,
    this.phenomenons,
    this.sensorId,
  });

  Feature.fromJSON(Map<String, dynamic> feature) {
    type = feature['type'] as String;
    geometry = feature['geometry'] as Geometry;
    time = feature['properties']['time'] as String;
    phenomenons = feature['properties']['phenomenons'] as Phenomenons;
    sensorId = feature['sensor'] as String;
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = 'Feature';
    data['geometry'] = geometry!.toJSON();
    data['properties'] = {
      'time': time,
      'phenomenons': phenomenons!.toJSON(),
      'sensor': sensorId
    };
    return data;
  }
}
