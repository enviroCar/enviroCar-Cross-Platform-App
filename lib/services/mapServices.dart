import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;

class MapServices {
  // Checks if location service is enabled
  // Prompts a dialogbox to ask to turn it on if disabled
  Future<bool> initializeLocationService() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    bool permissionStatus = true;

    if (!serviceEnabled) {
      permissionStatus = await loc.Location.instance.requestService();
    }

    return permissionStatus;
  }
}
