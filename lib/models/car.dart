class Car {
  String? username;
  String? type;
  Properties? properties;

  Car({
    required this.username,
    required this.type,
    required this.properties,
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

    data['properties'] = properties!.toJson();

    return data;
  }
}

class Properties {
  int? engineDisplacement;
  String? model;
  String? id;
  String? fuelType;
  int? constructionYear;
  String? manufacturer;

  Properties({
    required this.engineDisplacement,
    required this.model,
    required this.id,
    required this.fuelType,
    required this.constructionYear,
    required this.manufacturer,
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
