import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'bluetoothProvider.dart';
import '../screens/gpsTrackingScreen.dart';
import '../services/notification_service.dart';

class GpsTrackProvider extends ChangeNotifier {
  final Set<Marker> _markers = <Marker>{};
  final Set<Polyline> _polyLines = <Polyline>{};
  final Set<Circle> _circles = <Circle>{};
  final List<LatLng> _polyLineCoordinates = [];
  PolylinePoints _polylinePoints;
  bool isUserLocationDetermined;
  GoogleMapController _googleMapController;
  CameraPosition cameraPosition;
  bool isMounted;
  bool reloadMap;
  StreamSubscription<LocationData> streamSubscription;
  Timer _timer;
  Set<LatLng> latLngCoordinates;

  String trackStartTime = ' ';
  String trackEndTime = ' ';
  bool startTrack = true, endTrack = false;
  DateTime startTime, currentTime;
  String durationOfTrack = '0:00:00';

  String googleAPIKey = "AIzaSyDDTeCTv3rjbgtP4YQB_zlLGeMOvYcLAO0";

  LocationData startLocation;
  LocationData currentLocation;

  Location _location;

  BitmapDescriptor trackIcon;
  BitmapDescriptor startIcon;

  double cameraZoom = 15; // the magnification level of the camera position on the map
  double cameraTilt = 80; // the angle the camera points to the center location
  double cameraBearing = 100; // the direction the camera faces (north, south, east, west, etc)

  Duration defaultDuration = const Duration(seconds: 10);

  GpsTrackProvider() {
    isUserLocationDetermined = false;
    startLocation = null;
    currentLocation = null;
    isMounted = true;
    reloadMap = false;
    _location = Location();
    _polylinePoints = PolylinePoints();

    cameraPosition = CameraPosition(
        target: const LatLng(42.747932,-71.167889),
        zoom: cameraZoom,
        tilt: cameraTilt,
        bearing: cameraBearing
    );

    setUpMap();
  }

  // ignore: use_setters_to_change_properties, avoid_positional_boolean_parameters
  void trackScreenMounted(bool mounted) {
    isMounted = mounted;
  }

  Future setUpMap() async {
    isUserLocationDetermined = false;
    startLocation = null;
    currentLocation = null;
    isMounted = true;
    reloadMap = false;
    _location = Location();
    _polylinePoints = PolylinePoints();

    latLngCoordinates = {};
    durationOfTrack = '0:00:00';
    startTrack = true;
    endTrack = false;

    await setTrackIcon();
    await setInitialLocation();
    startTime = DateTime.now().toUtc();

    trackStartTime = startTime.toString().substring(0, 19);
    isUserLocationDetermined = true;
    notifyListeners();

    if (_location != null) {
      streamSubscription = _location.onLocationChanged.listen(listenToLocationUpdates);
    }

    NotificationService().showNotifications(trackId, 'GPS tracking has started!', GpsTrackingScreen.routeName);

    // adding the startLocation coordinates to set of lat lng coordinates
    latLngCoordinates.add(LatLng(startLocation.latitude, startLocation.longitude));

    logCoordinates();
  }

  void logCoordinates([Timer timer]) {
    _timer?.cancel();
    timer?.cancel();

    if (currentLocation != null) {
      latLngCoordinates.add(LatLng(currentLocation.latitude, currentLocation.longitude));
      debugPrint('the lat lng is ${startLocation.toString()} and ${currentLocation.toString()}');
    }

    BluetoothProvider().interactWithDevice();

    if (reloadMap) {
      return;
    }

    _timer = Timer(defaultDuration, logCoordinates);
  }

  /// function to set the [_googleMapController]
  Future setMapController(Future<GoogleMapController> googleMapController) async {
    _googleMapController = await googleMapController;
    notifyListeners();
  }

  /// function to listen to location updates
  void listenToLocationUpdates(LocationData locationData) {
    if (startTrack && !endTrack) {
      currentLocation = locationData;
      updatePins();
      currentTime = DateTime.now().toUtc();

      trackDuration();
    }
  }

  /// function to set the marker icons
  Future setTrackIcon() async {
    trackIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/tracking_pin.png'
    );

    startIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/source_pin.png'
    );
  }

  /// function to get current location of the user
  Future setInitialLocation() async {
    currentLocation = await _location.getLocation();
    startLocation = currentLocation;
    isUserLocationDetermined = true;
    setCameraPosition();
    notifyListeners();
  }

  /// function to update the camera position as current location is determined
  void setCameraPosition() {
    cameraPosition = CameraPosition(
        target: LatLng(
          currentLocation.latitude,
          currentLocation.longitude
        ),
        zoom: cameraZoom,
        tilt: cameraTilt,
        bearing: cameraBearing
    );

    notifyListeners();
  }

  /// function to update pin points on map
  void updatePins() {
    LatLngBounds latLngBounds;

    if (startLocation.latitude < currentLocation.latitude && startLocation.longitude < currentLocation.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(
          startLocation.latitude,
          startLocation.longitude
        ),
        northeast: LatLng(
          currentLocation.latitude,
          currentLocation.longitude
        )
      );
    }

    else if (startLocation.latitude < currentLocation.latitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(
          startLocation.latitude,
          currentLocation.longitude
        ),
        northeast: LatLng(
          currentLocation.latitude,
          startLocation.longitude
        )
      );
    }

    else if (startLocation.longitude < currentLocation.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(
          currentLocation.latitude,
          startLocation.longitude
        ),
        northeast: LatLng(
          startLocation.latitude,
          currentLocation.longitude
        )
      );
    }

    else {
      latLngBounds = LatLngBounds(
        southwest: LatLng(
          currentLocation.latitude,
          currentLocation.longitude
        ),
        northeast: LatLng(
          startLocation.latitude,
          startLocation.longitude
        )
      );
    }

    debugPrint(latLngBounds.toString());

    final newPinLocation = LatLng(currentLocation.latitude, currentLocation.longitude);

    cameraPosition = CameraPosition(
      target: newPinLocation,
      zoom: cameraZoom,
      tilt: cameraTilt,
      bearing: cameraBearing
    );

    if (isMounted && _googleMapController != null) {
      _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition));
    }

    _markers.removeWhere((element) => element.markerId.value == 'current');
    _circles.removeWhere((element) => element.circleId.value == 'current-circle');

    final Marker currentLocationMarker = Marker(
      markerId: const MarkerId('current'),
      position: newPinLocation,
      icon: trackIcon
    );

    _markers.add(currentLocationMarker);

    final Circle currentLocationCircle = Circle(
      circleId: const CircleId('current-circle'),
      center: newPinLocation,
      strokeColor: kWhiteColor,
      strokeWidth: 2,
      radius: 5,
      fillColor: kBlueColor
    );

    _circles.add(currentLocationCircle);

  }

  /// function to add markers and circles to [_markers] and [_circles]
  void addMarkersAndCircles() {
    final startPosition = LatLng(
      startLocation.latitude,
      startLocation.longitude
    );

    final currentPosition = LatLng(
      currentLocation.latitude,
      currentLocation.longitude
    );

    final Marker sourceMarker = Marker(
      markerId: const MarkerId('source'),
      position: startPosition,
      icon: startIcon,
      zIndex: 2
    );

    _markers.add(sourceMarker);

    final Marker currentMarker = Marker(
      markerId: const MarkerId('current'),
      position: currentPosition,
      icon: trackIcon,
      zIndex: 2
    );

    _markers.add(currentMarker);

    final Circle sourceCircle = Circle(
      circleId: const CircleId('source-circle'),
      strokeColor: kWhiteColor,
      center: startPosition,
      strokeWidth: 2,
      fillColor: kBlueColor,
      radius: 5
    );

    _circles.add(sourceCircle);

    final Circle currentCircle = Circle(
      circleId: const CircleId('current-circle'),
      strokeColor: kWhiteColor,
      center: currentPosition,
      strokeWidth: 2,
      fillColor: kBlueColor,
      radius: 5
    );

    _circles.add(currentCircle);

    setPolyLines();

    notifyListeners();

  }

  /// function to add poly lines on map
  Future setPolyLines() async {
    final PolylineResult polylineResult = await _polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      travelMode: TravelMode.driving
    );

    if (polylineResult.points.isEmpty) {
      debugPrint('error is ${polylineResult.errorMessage}');
    }

    if (polylineResult.points.isNotEmpty) {
      for (final PointLatLng pointLatLng in polylineResult.points) {
        final LatLng latLng = LatLng(pointLatLng.latitude, pointLatLng.longitude);
        _polyLineCoordinates.add(latLng);
      }

      final Polyline trackPolyline = Polyline(
        polylineId: const PolylineId('track'),
        width: 5,
        color: kBlueColor,
        points: _polyLineCoordinates
      );

      _polyLines.add(trackPolyline);
    }
  }

  /// function to get address of the location from latitude and longitude coordinates
  Future getAddress(double latitude, double longitude) async {
    final Response response = await get(Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleAPIKey'));
    debugPrint('response is ${response.body}');
  }

  /// function to calculate track duration
  void trackDuration() {
    final Duration duration = currentTime.difference(startTime);
    durationOfTrack = duration.toString().split('.').first;
    notifyListeners();
  }

  /// function to stop tracking
  void stopTrack() {
    endTrack = true;
    trackEndTime = DateTime.now().toUtc().toString().substring(0, 19);
    streamSubscription.cancel();
    latLngCoordinates.add(LatLng(currentLocation.latitude, currentLocation.longitude));
    NotificationService().turnOffNotification();
    debugPrint('tracking stopped at $trackEndTime');
    notifyListeners();
  }

  /// function to reset the values
  void resetAllValues() {
    startTrack = false;
    endTrack = true;
    _markers.clear();
    _polyLines.clear();
    _polyLineCoordinates.clear();
    _polylinePoints = null;
    isUserLocationDetermined = false;
    _googleMapController = null;
    _location = null;
    trackStartTime = ' ';
    trackEndTime = ' ';
    startTime = null;
    currentTime = null;
    startLocation = null;
    currentLocation = null;
    isMounted = false;
    reloadMap = true;

    cameraPosition = CameraPosition(
        target: const LatLng(42.747932,-71.167889),
        zoom: cameraZoom,
        tilt: cameraTilt,
        bearing: cameraBearing
    );
  }

  /// function to determine whether the user's current location is determined
  bool get locationDetermined => isUserLocationDetermined;

  /// function to get [durationOfTrack]
  String get getTrackDuration => durationOfTrack;

  /// function to get [_markers]
  Set<Marker> get getMarkers => {..._markers};

  /// function to get [_polyLines]
  Set<Polyline> get getPolyLines => {..._polyLines};

  /// function to get [_circles]
  Set<Circle> get getCircles => {..._circles};

  /// function to get [cameraPosition}
  CameraPosition get getCameraPosition => cameraPosition;

  /// function to get [trackId]
  String get trackId => trackStartTime;

  /// function to know the status of [endTrack]
  bool get getEndTrackStatus => endTrack;

  /// function to determine whether the map needs to be rebuilt
  bool get needsRebuild => reloadMap;

}