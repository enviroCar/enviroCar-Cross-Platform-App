import 'car.dart';

class Track {
  String id;
  String name;
  double length;
  DateTime begin;
  DateTime end;
  Car sensor;

  Track({
    this.id,
    this.name,
    this.length,
    this.begin,
    this.end,
    this.sensor,
  });

  Track.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    name = json['name'] as String;
    length = json['length'] as double;
    begin = DateTime.parse(json['begin'] as String);
    end = DateTime.parse(json['end'] as String);
    sensor = json['sensor'] != null
        ? Car.fromJson(json['sensor'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['length'] = length;
    data['begin'] = begin;
    data['end'] = end;
    if (sensor != null) {
      data['sensor'] = sensor.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'Track{id: $id, name: $name, length: $length, begin: $begin, end: $end, sensor: $sensor}';
  }
}
