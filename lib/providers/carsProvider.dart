import 'package:flutter/foundation.dart';

import '../models/car.dart';

class CarsProvider with ChangeNotifier {
  Car? _selectedCar;
  List<Car> _carsList = [];

  // sets the cars list fetched into the provider and notifies listeners
  set setCarsList(List<dynamic> carsList) {
    final List<Car> list = [];
    for (final dynamic carMap in carsList) {
      list.add(Car.fromJson(carMap));
    }

    _carsList = list;

    notifyListeners();
  }

  // gets the car that is currently selected
  Car? get getSelectedCar {
    return _selectedCar;
  }

  // sets the selected car in provider so that it can be fetched on other screens
  set setSelectedCar(Car car) {
    _selectedCar = car;

    notifyListeners();
  }

  // to show on the cars screen
  List<Car> get getCarsList {
    return _carsList;
  }

  // When new car is created
  void addCar(Car newCar) {
    _carsList = [];
    _carsList.add(newCar);

    notifyListeners();
  }

  // when car is deleted
  void deleteCar(Car car) {
    _carsList.removeWhere(
      (Car carItem) {
        return carItem.properties!.id == car.properties!.id;
      },
    );

    notifyListeners();
  }
}
