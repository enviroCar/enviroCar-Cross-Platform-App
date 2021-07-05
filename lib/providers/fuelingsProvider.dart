import 'package:flutter/foundation.dart';

import '../models/car.dart';
import '../models/fueling.dart';

// Provides data of the Log Book
class FuelingsProvider with ChangeNotifier {
  // Dummy list for fueling data
  List<Fueling> _fuelingsList = [
    Fueling(
      id: '1',
      car: Car(
        id: '1',
        manufacturer: 'Volkswagen',
        model: 'S309',
        constructionYear: 1930,
        fuelType: 'Diesel',
        engineDisplacement: 1600,
        // isSelected: true,
      ),
      mileage: '25',
      fueledVolume: '25',
      totalPrice: '25',
      pricePerLitre: '25',
      partialFueling: true,
      missedPreviousFueling: true,
      comment: 'Hello There',
    ),
    Fueling(
      id: '2',
      car: Car(
        id: '2',
        manufacturer: 'BMW',
        model: 'M3-GT',
        constructionYear: 1930,
        fuelType: 'Diesel',
        engineDisplacement: 1600,
        // isSelected: false,
      ),
      mileage: '25',
      fueledVolume: '25',
      totalPrice: '25',
      pricePerLitre: '25',
      partialFueling: false,
      missedPreviousFueling: true,
      comment: 'Hello There',
    ),
    Fueling(
      id: '3',
      car: Car(
        id: '3',
        manufacturer: 'Ferrari',
        model: 'Ultra',
        constructionYear: 1930,
        fuelType: 'Diesel',
        engineDisplacement: 1600,
        // isSelected: false,
      ),
      mileage: '25',
      fueledVolume: '25',
      totalPrice: '25',
      pricePerLitre: '25',
      partialFueling: false,
      missedPreviousFueling: true,
      comment: 'Hello There',
    ),
  ];

  // Adds newly created fueling data and notifies log book screen
  void addFueling(Fueling fueling) {
    _fuelingsList.add(fueling);

    notifyListeners();
  }

  // TODO: Write method to delete using ID
  void deleteFueling() {}

  // get method to get the list data
  get getFuelingsList {
    return _fuelingsList;
  }
}
