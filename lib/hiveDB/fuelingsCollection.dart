import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authProvider.dart';
import '../providers/fuelingsProvider.dart';

// Local Hive DB Collection for fueling logs

class FuelingsCollection {
  // opens the box to fetch data from and store data into
  Future<void> openFuelingsHive() async {
    await Hive.openBox('fuelingsBox');
  }

  // adds a new fueling log to the box
  Future<void> addFuelingToHive({@required dynamic fueling}) async {
    await Hive.box('fuelingsBox').add(
      fueling,
    );
  }

  // fetches all the fueling logs from the box if there's no internet
  void getFuelingsFromHive({required BuildContext context}) {
    final FuelingsProvider fuelingsProvider =
        Provider.of<FuelingsProvider>(context, listen: false);

    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    final String? username = authProvider.getUser?.getUsername;

    final List<dynamic> fuelingsList = [];

    for (final dynamic fueling in Hive.box('fuelingsBox').toMap().values) {
      if (fueling['username'] == username) {
        fuelingsList.add(fueling);
      }
    }

    fuelingsProvider.setFuelingsList = fuelingsList;
  }
}
