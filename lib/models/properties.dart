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
    engineDisplacement = json['engineDisplacement'];
    model = json['model'];
    id = json['id'];
    fuelType = json['fuelType'];
    constructionYear = json['constructionYear'];
    manufacturer = json['manufacturer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['engineDisplacement'] = this.engineDisplacement;
    data['model'] = this.model;
    data['id'] = this.id;
    data['fuelType'] = this.fuelType;
    data['constructionYear'] = this.constructionYear;
    data['manufacturer'] = this.manufacturer;
    return data;
  }
}
