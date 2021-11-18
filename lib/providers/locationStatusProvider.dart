import 'package:flutter/foundation.dart';

import '../utils/enums.dart';
import '../services/locationStatusChecker.dart';

class LocationStatusProvider extends ChangeNotifier {
  LocationStatus locationStatus;

  LocationStatusProvider() {
    locationStatus = LocationStatus.disabled;
    sendStatusUpdates();
  }

  /// function to update location stream upon listening to status updates
  Future sendStatusUpdates() async {
    LocationStatusChecker().onStatusChange.listen((status) {
      locationStatus = status;
      notifyListeners();
    });
  }

  /// function to get current [locationStatus]
  LocationStatus get locationState => locationStatus;
}
