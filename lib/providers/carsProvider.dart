import 'package:flutter/foundation.dart';

import '../models/car.dart';

class CarsProvider with ChangeNotifier {
  Car _selectedCar;
  List<Car> _carsList;

  set setCarsList(List<Map<String, dynamic>> carsList) {
    final List<Car> list = [];
    for (final Map<String, dynamic> carMap in carsList) {
      list.add(Car.fromJson(carMap));

      notifyListeners();
    }

    _carsList = list;
  }

  Car get getSelectedCar {
    return _selectedCar;
  }

  set setSelectedCar(Car car) {
    _selectedCar = car;

    notifyListeners();
  }

  List<Car> get getCarsList {
    return _carsList;
  }

  void addCar(Car newCar) {
    _carsList.add(newCar);

    notifyListeners();
  }

  void deleteCar(Car car) {
    _carsList.removeWhere(
      (Car carItem) {
        return carItem.id == car.id;
      },
    );

    notifyListeners();
  }

  void markAsSelected(String id) {}
}
