class Car {
  int id;
  String manufacturer;
  String model;
  int constructionYear;
  String fuelType;
  int engineDisplacement;

  Car({
    this.id,
    this.manufacturer,
    this.model,
    this.constructionYear,
    this.fuelType,
    this.engineDisplacement,
  });

  Car.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    manufacturer = json['manufacturer'] as String;
    model = json['model'] as String;
    constructionYear = json['constructionYear'] as int;
    fuelType = json['fuelType'] as String;
    engineDisplacement = json['engineDisplacement'] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['manufacturer'] = manufacturer;
    data['model'] = model;
    data['constructionYear'] = constructionYear;
    data['fuelType'] = fuelType;
    data['engineDisplacement'] = engineDisplacement;

    return data;
  }
}
