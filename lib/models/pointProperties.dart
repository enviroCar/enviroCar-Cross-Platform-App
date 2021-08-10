import 'package:hive/hive.dart';

import '../constants.dart';

part 'pointProperties.g.dart';

@HiveType(typeId: kPointPropertiesId)
class PointProperties extends HiveObject {
  @HiveField(0)
  double latitude;
  @HiveField(1)
  double longitude;
  @HiveField(2)
  double altitude;
  @HiveField(3)
  double consumption;
  @HiveField(4)
  double co2;
  @HiveField(5)
  double speed;
  @HiveField(6)
  double maf;
  @HiveField(7)
  String time;

  PointProperties({
    this.latitude,
    this.longitude,
    this.altitude,
    this.consumption,
    this.co2,
    this.speed,
    this.maf,
    this.time
  });

  PointProperties.fromJSON(Map<String, dynamic> pointProperties) {
    latitude = pointProperties['latitude'] as double;
    longitude = pointProperties['longitude'] as double;
    altitude = pointProperties['altitude'] as double;
    consumption = pointProperties['Consumption'] as double;
    co2 = pointProperties['CO2'] as double;
    speed = pointProperties['Speed'] as double;
    maf = pointProperties['MAF'] as double;
    time = pointProperties['time'] as String;
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['altitude'] = altitude;
    data['Consumption'] = consumption;
    data['CO2'] = co2;
    data['Speed'] = speed;
    data['MAF'] = maf;
    data['time'] = time;
    return data;
  }

}