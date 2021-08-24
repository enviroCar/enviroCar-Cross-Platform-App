import './car.dart';

class Fueling {
  String id;
  String username;
  String fuelType;
  String comment;
  UnitValue cost;
  UnitValue mileage;
  UnitValue volume;
  bool missedFuelStop;
  bool partialFueling;
  String time;
  Car car;

  Fueling(
      {this.id,
      this.username,
      this.fuelType,
      this.comment,
      this.cost,
      this.mileage,
      this.volume,
      this.missedFuelStop,
      this.partialFueling,
      this.time,
      this.car});

  Fueling.fromJson(dynamic json) {
    id = json['id'] as String;
    username = json['username'] as String;
    fuelType = json['fuelType'] as String;
    comment = json['comment'] as String;
    cost = json['cost'] != null ? UnitValue.fromJson(json['cost']) : null;
    mileage =
        json['mileage'] != null ? UnitValue.fromJson(json['mileage']) : null;
    volume = json['volume'] != null ? UnitValue.fromJson(json['volume']) : null;
    missedFuelStop = json['missedFuelStop'] as bool;
    partialFueling = json['partialFueling'] as bool;
    time = json['time'] as String;
    car = Car.fromJson(json['car']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['fuelType'] = fuelType;
    data['comment'] = comment;
    if (cost != null) {
      data['cost'] = cost.toJson();
    }
    if (mileage != null) {
      data['mileage'] = mileage.toJson();
    }
    if (volume != null) {
      data['volume'] = volume.toJson();
    }
    data['missedFuelStop'] = missedFuelStop;
    data['partialFueling'] = partialFueling;
    data['time'] = time;
    data['car'] = car.properties.id;
    return data;
  }
}

class UnitValue {
  String unit;
  dynamic value;

  UnitValue({this.unit, this.value});

  UnitValue.fromJson(dynamic json) {
    unit = json['unit'] as String;
    value = json['value'] as dynamic;
  }

  dynamic toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['unit'] = unit;
    data['value'] = value;

    return data;
  }
}
