import 'package:flutter/foundation.dart';

import './car.dart';

// Model for Fueling data in Log Book
class Fueling {
  String id;
  Car car;
  String mileage;
  String fueledVolume;
  String pricePerLitre;
  String totalPrice;
  bool partialFueling;
  bool missedPreviousFueling;
  String comment;

  // TODO: Add datetime attribute

  Fueling({
    @required this.id,
    @required this.car,
    @required this.mileage,
    @required this.fueledVolume,
    @required this.totalPrice,
    @required this.pricePerLitre,
    @required this.partialFueling,
    @required this.missedPreviousFueling,
    @required this.comment,
  });
}
