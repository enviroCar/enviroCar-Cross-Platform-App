import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/carsProvider.dart';
import '../providers/authProvider.dart';

// Local Hive DB Collection for cars

class CarsCollection {
  // opens the cars box to later fetch from and store data into
  Future<void> openCarsHive() async {
    await Hive.openBox('carsBox');
  }

  // adds cars to the box
  Future<void> addCarToHive({@required Map<String, dynamic> car}) async {
    await Hive.box('carsBox').add(
      car,
    );
  }

  // fetches all the cars from the box
  void getCarsFromHive({@required BuildContext context}) {
    final CarsProvider carsProvider =
        Provider.of<CarsProvider>(context, listen: false);

    final String username =
        Provider.of<AuthProvider>(context, listen: false).getUser.getUsername;

    final List<dynamic> carsList = [];

    for (final dynamic car in Hive.box('carsBox').toMap().values) {
      if (car['username'] == username) {
        carsList.add(car);
      }
    }

    Future.delayed(
      const Duration(),
      () {
        carsProvider.setCarsList = carsList;
      },
    );
  }
}
