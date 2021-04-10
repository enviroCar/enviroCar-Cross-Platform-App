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
    id = json['id'];
    length = json['length'];
    begin = DateTime.parse(json['begin']);
    end = DateTime.parse(json['end']);
    sensor =
        json['sensor'] != null ? new Sensor.fromJson(json['sensor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['length'] = this.length;
    data['begin'] = this.begin;
    data['end'] = this.end;
    if (this.sensor != null) {
      data['sensor'] = this.sensor.toJson();
    }
    return data;
  }
}
