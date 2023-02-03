import 'package:flutter/foundation.dart';

import '../models/fueling.dart';

// Provides data of the Log Book
class FuelingsProvider with ChangeNotifier {
  List<Fueling> _fuelingsList = [];

  // Adds newly created fueling data and notifies log book screen
  void addFueling(Fueling fueling) {
    // if list is null then create an empty list to add to
    _fuelingsList ??= [];
    _fuelingsList.add(fueling);

    notifyListeners();
  }

  // delete fueling log from ID
  void deleteFueling({required String id}) {
    _fuelingsList.removeWhere((Fueling fueling) => fueling.id == id);
  }

  // after fetching from the server or Hive
  set setFuelingsList(List<dynamic> fuelingsList) {
    final List<Fueling> list = [];
    for (final dynamic fuelingMap in fuelingsList) {
      list.add(Fueling.fromJson(fuelingMap));
    }

    _fuelingsList = list;

    notifyListeners();
  }

  // get method to get the list data
  List<Fueling> get getFuelingsList {
    return _fuelingsList;
  }
}
