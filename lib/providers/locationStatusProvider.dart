import 'package:flutter/foundation.dart';

import '../utils/enums.dart';
import '../services/locationStatusChecker.dart';

class LocationStatusProvider extends ChangeNotifier {
  LocationStatus locationStatus;

  factory LocationStatusProvider() => _locationStatusProvider;

  LocationStatusProvider._() {
    locationStatus = LocationStatus.disabled;
    updateLocationStatus();
  }

  static final LocationStatusProvider _locationStatusProvider = LocationStatusProvider._();

  /// function to update location stream upon listening to status updates
  Future updateLocationStatus() async {
    LocationStatusChecker().onStatusChange.listen((status) {
      locationStatus = status;
      notifyListeners();
    });
  }

  /// function to get current [locationStatus]
  LocationStatus get locationState => locationStatus;

}