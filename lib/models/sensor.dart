import './properties.dart';

class Sensor {
  String type;
  Properties properties;

  Sensor({
    this.type,
    this.properties,
  });

  Sensor.fromJson(Map<String, dynamic> json) {
    type = json['type'] as String;
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (properties != null) {
      data['properties'] = properties.toJson();
    }
    return data;
  }
}
