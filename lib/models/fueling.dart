import 'car.dart';

class Fueling {
  String id;
  Car car;
  String fuelType;
  String comment;
  int cost;
  String costUnit;
  int mileage;
  String milageUnit;
  bool missedFuelStop;
  bool partialFueling;
  int time;
  int volume;
  String volumeUnit;

  Fueling(
      {this.id,
      this.car,
      this.fuelType,
      this.comment,
      this.cost,
      this.costUnit,
      this.mileage,
      this.milageUnit,
      this.missedFuelStop,
      this.partialFueling,
      this.time,
      this.volume,
      this.volumeUnit});

  Fueling.fromJson(Map<String, dynamic> json) {
    id = json['car'] as String;
    car = json['car'] != null
        ? Car.fromJson(json['car'] as Map<String, dynamic>)
        : null;
    fuelType = json['fuelType'] as String;
    comment = json['comment'] as String;
    cost = json['cost'] as int;
    costUnit = json['costUnit'] as String;
    mileage = json['mileage'] as int;
    milageUnit = json['milageUnit'] as String;
    missedFuelStop = json['missedFuelStop'] as bool;
    partialFueling = json['partialFueling'] as bool;
    time = json['time'] as int;
    volume = json['volume'] as int;
    volumeUnit = json['volumeUnit'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (car != null) {
      data['car'] = car.toJson();
    }
    data['fuelType'] = fuelType;
    data['comment'] = comment;
    data['cost'] = cost;
    data['costUnit'] = costUnit;
    data['mileage'] = mileage;
    data['milageUnit'] = milageUnit;
    data['missedFuelStop'] = missedFuelStop;
    data['partialFueling'] = partialFueling;
    data['time'] = time;
    data['volume'] = volume;
    data['volumeUnit'] = volumeUnit;
    return data;
  }
}
