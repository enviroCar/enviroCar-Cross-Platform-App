import 'package:flutter/foundation.dart';

import '../models/car.dart';

class CarsProvider with ChangeNotifier {
  Car _selectedCar;
  List<Car> _carsList = [
    Car(
      id: '1',
      manufacturer: 'Volkswagen',
      model: 'S309',
      constructionYear: 1930,
      fuelType: 'Diesel',
      engineDisplacement: 1600,
      // isSelected: true,
    ),
    Car(
      id: '2',
      manufacturer: 'BMW',
      model: 'M3-GT',
      constructionYear: 1930,
      fuelType: 'Diesel',
      engineDisplacement: 1600,
      // isSelected: false,
    ),
    Car(
      id: '3',
      manufacturer: 'Ferrari',
      model: 'Ultra',
      constructionYear: 1930,
      fuelType: 'Diesel',
      engineDisplacement: 1600,
      // isSelected: false,
    ),
    Car(
      id: '4',
      manufacturer: 'Hector',
      model: 'SH43',
      constructionYear: 1930,
      fuelType: 'Diesel',
      engineDisplacement: 1600,
      // isSelected: false,
    ),
    Car(
      id: '5',
      manufacturer: 'Audi',
      model: 'R8',
      constructionYear: 1930,
      fuelType: 'Diesel',
      engineDisplacement: 1600,
      // isSelected: false,
    ),
    Car(
      id: '6',
      manufacturer: 'Mercedez',
      model: 'Benz',
      constructionYear: 1930,
      fuelType: 'Diesel',
      engineDisplacement: 1600,
      // isSelected: false,
    ),
    Car(
      id: '7',
      manufacturer: 'Rolls Royce',
      model: 'Antique',
      constructionYear: 1930,
      fuelType: 'Diesel',
      engineDisplacement: 1600,
      // isSelected: false,
    ),
  ];

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
        return (carItem.id == car.id);
      },
    );

    notifyListeners();
  }

  void markAsSelected(String id) {}
}
