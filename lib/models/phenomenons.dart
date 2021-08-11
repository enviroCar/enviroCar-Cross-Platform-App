class Phenomenons {
  double consumption;
  double co2;
  double speed;
  double maf;

  Phenomenons({
    this.consumption,
    this.co2,
    this.speed,
    this.maf
  });

  Phenomenons.fromJSON(Map<String, dynamic> phenomenons) {
    consumption = phenomenons['Consumption']['value'] as double;
    co2 = phenomenons['CO2']['value'] as double;
    speed = phenomenons['Speed']['value'] as double;
    maf = phenomenons['MAF']['value'] as double;
  }

  Map<String, dynamic> toJSON() {
    final Map<String, Map<String, dynamic>> data = {};
    data['Consumption'] = {
      'value': consumption
    };
    data['CO2'] = {
      'value': co2
    };
    data['Speed'] = {
      'value': speed
    };
    data['MAF'] = {
      'value': maf
    };
    return data;
  }

}