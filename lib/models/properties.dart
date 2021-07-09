class Properties {
  int engineDisplacement;
  String model;
  String id;
  String fuelType;
  int constructionYear;
  String manufacturer;

  Properties({
    this.engineDisplacement,
    this.model,
    this.id,
    this.fuelType,
    this.constructionYear,
    this.manufacturer,
  });

  Properties.fromJson(Map<String, dynamic> json) {
    engineDisplacement = json['engineDisplacement'] as int;
    model = json['model'] as String;
    id = json['id'] as String;
    fuelType = json['fuelType'] as String;
    constructionYear = json['constructionYear'] as int;
    manufacturer = json['manufacturer'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['engineDisplacement'] = engineDisplacement;
    data['model'] = model;
    data['id'] = id;
    data['fuelType'] = fuelType;
    data['constructionYear'] = constructionYear;
    data['manufacturer'] = manufacturer;
    return data;
  }
}
