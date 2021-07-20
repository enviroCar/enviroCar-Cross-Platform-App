import './sensor.dart';

class Track {
  String id;
  double length;
  DateTime begin;
  DateTime end;
  Sensor sensor;

  Track({
    this.id,
    this.length,
    this.begin,
    this.end,
    this.sensor,
  });

  Track.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    length = json['length'] as double;
    begin = DateTime.parse(json['begin'] as String);
    end = DateTime.parse(json['end'] as String);
    sensor = json['sensor'] != null
        ? Sensor.fromJson(json['sensor'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['length'] = length;
    data['begin'] = begin;
    data['end'] = end;
    if (sensor != null) {
      data['sensor'] = sensor.toJson();
    }
    return data;
  }
}
