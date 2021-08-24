class Car {
  String username;
  String type;
  Properties properties;

  Car({
    this.username,
    this.type,
    this.properties,
  });

  Car.fromJson(dynamic json) {
    username = json['username'] as String;
    type = json['type'] as String;
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'] as dynamic)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['type'] = type;
    if (properties != null) {
      data['properties'] = properties.toJson();
    }
    return data;
  }
}

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

  Properties.fromJson(dynamic json) {
    engineDisplacement = json['engineDisplacement'] as int;
    model = json['model'] as String;
    id = json['id'] as String;
    fuelType = json['fuelType'] as String;
    constructionYear = json['constructionYear'] as int;
    manufacturer = json['manufacturer'] as String;
  }

  dynamic toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['engineDisplacement'] = engineDisplacement;
    data['model'] = model;
    if (id != null) {
      data['id'] = id;
    }
    data['fuelType'] = fuelType;
    data['constructionYear'] = constructionYear;
    data['manufacturer'] = manufacturer;
    return data;
  }
}
