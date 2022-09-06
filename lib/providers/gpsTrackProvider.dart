import 'dart:async';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../constants.dart';
import '../models/car.dart';
import '../utils/dateUtil.dart';
import 'bluetoothProvider.dart';
import '../obd/obdCommands.dart';
import '../obd/string_util.dart';
import '../models/pointProperties.dart';
import '../models/localTrackModel.dart';
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
  Timer _timeCounter;
  Map<int, PointProperties> pointProperties;

  String trackStartTime = ' ';
  String trackEndTime = ' ';
  String trackName = ' ';
  bool startTrack = true;
  bool endTrack = false;
  String durationOfTrack = '0:00:00';
  int time;
  int stopsCount;
  double distance;
  Duration duration;
  double altitude;
  double consumption;
  double co2;
  double speed;
  double maf;
  int count;

  LocationData startLocation;
  LocationData currentLocation;

  Location _location;

  BitmapDescriptor trackIcon;
  BitmapDescriptor startIcon;

  double cameraZoom =
      15; // the magnification level of the camera position on the map
  double cameraTilt = 80; // the angle the camera points to the center location
  double cameraBearing =
      100; // the direction the camera faces (north, south, east, west, etc)

  Duration defaultDuration = const Duration(seconds: 10);
  Duration timeCounterDuration = const Duration(seconds: 1);

  factory GpsTrackProvider() => _gpsTrackProvider;

  GpsTrackProvider._() {
    isUserLocationDetermined = false;
    startLocation = null;
    currentLocation = null;
    isMounted = true;
    reloadMap = false;
    _location = Location();
    _polylinePoints = PolylinePoints();

    cameraPosition = CameraPosition(
      target: const LatLng(42.747932, -71.167889),
      zoom: cameraZoom,
      tilt: cameraTilt,
      bearing: cameraBearing,
    );

    setUpMap();
  }

  static final GpsTrackProvider _gpsTrackProvider = GpsTrackProvider._();

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

    pointProperties = {};
    durationOfTrack = '0:00:00';
    startTrack = true;
    endTrack = false;
    duration = Duration.zero;

    time = 0;
    stopsCount = 0;
    distance = 0;
    consumption = 0;
    co2 = 0;
    speed = 0;
    maf = 0;
    count = 1;

    await setTrackIcon();
    await setInitialLocation();

    trackStartTime = DateTime.now().toUtc().toString().substring(0, 19);
    trackName = 'Track $trackId';
    isUserLocationDetermined = true;
    notifyListeners();

    if (_location != null) {
      streamSubscription =
          _location.onLocationChanged.listen(listenToLocationUpdates);
    }

    NotificationService().showNotifications(
      trackId,
      'GPS tracking has started!',
      GpsTrackingScreen.routeName,
    );

    collectFeatureData();
    trackDuration();
  }

  Future collectFeatureData([Timer timer]) async {
    _timer?.cancel();
    timer?.cancel();

    if (currentLocation != null && !isTrackingPaused && _location != null) {
      altitude = currentLocation.altitude;
      // todo: update and set speed, consumption, co2, maf from parsed data
      BluetoothProvider().interactWithDevice(
        stringToIntList(obdRequestSymbol['SPD'] + returnSymbol),
      );
      String time = DateTime.now()
          .toUtc()
          .toString()
          .substring(0, 19)
          .replaceAll(" ", "T");
      time = '${time}Z';

      final PointProperties properties = PointProperties(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude,
        altitude: currentLocation.altitude,
        consumption: consumption,
        co2: co2,
        speed: speed,
        maf: maf,
        time: time,
      );

      pointProperties[count] = properties;
      count++;
    }

    if (reloadMap || isTrackingPaused) {
      return;
    }

    _timer = Timer(defaultDuration, collectFeatureData);
  }

  /// function to set the [_googleMapController]
  Future setMapController(
    Future<GoogleMapController> googleMapController,
  ) async {
    _googleMapController = await googleMapController;
    notifyListeners();
  }

  /// function to listen to location updates
  void listenToLocationUpdates(LocationData locationData) {
    if (startTrack && !endTrack) {
      currentLocation = locationData;
      updatePins();
    }
  }

  /// function to set the marker icons
  Future setTrackIcon() async {
    trackIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/tracking_pin.png',
    );

    startIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/source_pin.png',
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
        currentLocation.longitude,
      ),
      zoom: cameraZoom,
      tilt: cameraTilt,
      bearing: cameraBearing,
    );

    notifyListeners();
  }

  /// function to update pin points on map
  void updatePins() {
    final newPinLocation =
        LatLng(currentLocation.latitude, currentLocation.longitude);

    cameraPosition = CameraPosition(
      target: newPinLocation,
      zoom: cameraZoom,
      tilt: cameraTilt,
      bearing: cameraBearing,
    );

    if (isMounted && _googleMapController != null) {
      _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
    }

    _markers.removeWhere((element) => element.markerId.value == 'current');
    _circles
        .removeWhere((element) => element.circleId.value == 'current-circle');

    final Marker currentLocationMarker = Marker(
      markerId: const MarkerId('current'),
      position: newPinLocation,
      icon: trackIcon,
    );

    _markers.add(currentLocationMarker);

    final Circle currentLocationCircle = Circle(
      circleId: const CircleId('current-circle'),
      center: newPinLocation,
      strokeColor: kWhiteColor,
      strokeWidth: 2,
      radius: 5,
      fillColor: kBlueColor,
    );

    _circles.add(currentLocationCircle);

    // determine the distance between start position and current position
    distance = GeolocatorPlatform.instance.distanceBetween(
      startLocation.latitude,
      startLocation.longitude,
      currentLocation.latitude,
      currentLocation.longitude,
    );

    distance /= 1000; // distance in km

    notifyListeners();
  }

  /// function to add markers and circles to [_markers] and [_circles]
  void addMarkersAndCircles() {
    final startPosition = LatLng(
      startLocation.latitude,
      startLocation.longitude,
    );

    final currentPosition = LatLng(
      currentLocation.latitude,
      currentLocation.longitude,
    );

    final Marker sourceMarker = Marker(
      markerId: const MarkerId('source'),
      position: startPosition,
      icon: startIcon,
      zIndex: 2,
    );

    _markers.add(sourceMarker);

    final Marker currentMarker = Marker(
      markerId: const MarkerId('current'),
      position: currentPosition,
      icon: trackIcon,
      zIndex: 2,
    );

    _markers.add(currentMarker);

    final Circle sourceCircle = Circle(
      circleId: const CircleId('source-circle'),
      strokeColor: kWhiteColor,
      center: startPosition,
      strokeWidth: 2,
      fillColor: kBlueColor,
      radius: 5,
    );

    _circles.add(sourceCircle);

    final Circle currentCircle = Circle(
      circleId: const CircleId('current-circle'),
      strokeColor: kWhiteColor,
      center: currentPosition,
      strokeWidth: 2,
      fillColor: kBlueColor,
      radius: 5,
    );

    _circles.add(currentCircle);

    setPolyLines();

    notifyListeners();
  }

  /// function to add poly lines on map
  Future setPolyLines() async {
    final PolylineResult polylineResult =
        await _polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      travelMode: TravelMode.driving,
    );

    if (polylineResult.points.isEmpty) {
      debugPrint('error is ${polylineResult.errorMessage}');
    }

    if (polylineResult.points.isNotEmpty) {
      for (final PointLatLng pointLatLng in polylineResult.points) {
        final LatLng latLng =
            LatLng(pointLatLng.latitude, pointLatLng.longitude);
        _polyLineCoordinates.add(latLng);
      }

      final Polyline trackPolyline = Polyline(
        polylineId: const PolylineId('track'),
        width: 5,
        color: kBlueColor,
        points: _polyLineCoordinates,
      );

      _polyLines.add(trackPolyline);
    }
  }

  /// function to get address of the location from latitude and longitude coordinates
  Future getAddress(double latitude, double longitude) async {
    final Response response = await get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleAPIKey',
      ),
    );
    debugPrint('response is ${response.body}');
  }

  /// function to calculate track duration
  void trackDuration([Timer timer]) {
    _timeCounter?.cancel();
    timer?.cancel();

    if (!isTrackingPaused) {
      time++;
      final int seconds = (time - 1) % 60;
      final double minutes = ((time - 1) / 60) % 60;
      final double hours = time / 3600;
      duration = Duration(
        hours: hours.toInt(),
        minutes: minutes.toInt(),
        seconds: seconds,
      );
      durationOfTrack =
          '${hours.toInt()}:${minutes < 10 ? '0${minutes.toInt()}' : minutes.toInt()}:${seconds < 10 ? '0$seconds' : seconds}';
      notifyListeners();
    }

    if (reloadMap || isTrackingPaused || _location == null) {
      return;
    }

    _timeCounter = Timer(timeCounterDuration, trackDuration);
  }

  /// function to stop tracking
  void stopTrack() {
    endTrack = true;
    trackEndTime = DateTime.now().toUtc().toString().substring(0, 19);
    streamSubscription.cancel();
    isUserLocationDetermined = false;
    _location = null;

    String time =
        DateTime.now().toUtc().toString().substring(0, 19).replaceAll(" ", "T");
    time = '${time}Z';

    final PointProperties properties = PointProperties(
      latitude: currentLocation.latitude,
      longitude: currentLocation.longitude,
      altitude: currentLocation.altitude,
      consumption: consumption,
      co2: co2,
      speed: speed,
      maf: maf,
      time: time,
    );

    pointProperties[count] = properties;
    NotificationService().turnOffNotification();
    debugPrint('tracking stopped at $trackEndTime no of stops is $stopsCount');
    notifyListeners();
  }

  /// function to pause the tracking by pausing the [streamSubscription]
  void pauseTracking() {
    streamSubscription.pause();
    stopsCount++;
  }

  /// function to resume the tracking by subscribing again or resuming the [streamSubscription]
  void resumeTracking() {
    streamSubscription.resume();

    collectFeatureData();
    trackDuration();
  }

  /// function to set [trackName]
  void setTrackName(String name) {
    trackName = name;
    notifyListeners();
  }

  /// function to get [LocalTrack] object
  LocalTrackModel getLocalTrack({@required Car sensor}) {
    final LocalTrackModel trackModel = LocalTrackModel(
      trackId: trackId,
      trackName: getTrackName,
      startTime: formatDate(trackStartTime),
      endTime: formatDate(trackEndTime),
      duration: getTrackDuration,
      distance: getDistance,
      speed: 40, // todo: change hardcoded value
      selectedCarId: sensor.properties.id,
      isTrackUploaded: false,
      stops: getNoOfStops,
      bluetoothDevice: BluetoothProvider().getConnectedDevice.name,
      properties: pointProperties,
      carManufacturer: sensor.properties.manufacturer,
      carModel: sensor.properties.model,
      carFuelType: sensor.properties.fuelType,
      carEngineDisplacement: sensor.properties.engineDisplacement,
      carConstructionYear: sensor.properties.constructionYear,
    );

    return trackModel;
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
    trackName = ' ';
    startLocation = null;
    currentLocation = null;
    isMounted = false;
    reloadMap = true;
    duration = null;

    cameraPosition = CameraPosition(
      target: const LatLng(42.747932, -71.167889),
      zoom: cameraZoom,
      tilt: cameraTilt,
      bearing: cameraBearing,
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

  /// function to get [trackName]
  String get getTrackName => trackName;

  /// function to get [trackStartTime]
  String get getTrackStartTime => trackStartTime;

  /// function to get [trackEndTime]
  String get getTrackEndTime => trackEndTime;

  /// function to get [stopsCount]
  int get getNoOfStops => stopsCount;

  /// function to get [distance] between [startLocation] and [currentLocation]
  double get getDistance => distance;

  /// function to get [duration] of the [track]
  Duration get getDuration => duration;

  /// function to determine whether tracking is stopped
  bool get isTrackingPaused => streamSubscription.isPaused;

  /// function to determine whether the map needs to be rebuilt
  bool get needsRebuild => reloadMap;
}
