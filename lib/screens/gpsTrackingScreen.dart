import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';

import '../constants.dart';
import '../globals.dart';
import '../providers/bluetoothProvider.dart';
import '../utils/enums.dart';
import '../providers/locationStatusProvider.dart';

class GpsTrackingScreen extends StatefulWidget {
  static String routeName = '/gpsTracking';

  @override
  _GpsTrackingScreenState createState() => _GpsTrackingScreenState();
}

class _GpsTrackingScreenState extends State<GpsTrackingScreen> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  final Set<Marker> _markers = <Marker>{};
  final Set<Polyline> _polyLines = <Polyline>{};
  final Set<Circle> _circles = <Circle>{};
  final List<LatLng> _polyLineCoordinates = [];
  PolylinePoints _polylinePoints;

  String googleAPIKey = "AIzaSyDDTeCTv3rjbgtP4YQB_zlLGeMOvYcLAO0";

  LocationData startLocation;
  LocationData currentLocation;

  Location _location;

  BitmapDescriptor trackIcon;
  BitmapDescriptor startIcon;

  static const double CAMERA_ZOOM = 15; // the magnification level of the camera position on the map
  static const double CAMERA_TILT = 80; // the angle the camera points to the center location
  static const double CAMERA_BEARING = 100; // the direction the camera faces (north, south, east, west, etc)

  String trackStartTime = ' ';
  String trackEndTime = ' ';
  bool startTrack = true, endTrack = false;
  DateTime startTime, currentTime;
  String durationOfTrack = ' ';

  @override
  void initState() {
    _location = Location();
    _polylinePoints = PolylinePoints();

    trackStartTime = DateTime.now().toUtc().toString().substring(0, 19);
    startTime = DateTime.now().toUtc();

    _location.onLocationChanged.listen(listenToLocationUpdates);

    setTrackIcon();
    setInitialLocation();

    super.initState();
  }

  void listenToLocationUpdates(LocationData locationData) {
    if (startTrack && !endTrack) {
      currentLocation = locationData;
      if (mounted) {
        updatePinOnMap();
      }
      currentTime = DateTime.now().toUtc();
      debugPrint('start time ${startTime.toString()} end time ${currentTime.toString()}');
      trackDuration();
    }
  }

  Future setInitialLocation() async {
    currentLocation = await _location.getLocation();
    // getAddress(currentLocation.latitude, currentLocation.longitude);
    startLocation = currentLocation;
  }

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

  Future getAddress(double latitude, double longitude) async {
    final Response response = await get(Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleAPIKey'));
    debugPrint('response is ${response.body}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    CameraPosition cameraPosition = const CameraPosition(
      target: LatLng(42.747932,-71.167889),
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING
    );

    if (startLocation != null) {
      cameraPosition = CameraPosition(
          target: LatLng(
            startLocation.latitude,
            startLocation.longitude
          ),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            markers: _markers,
            polylines: _polyLines,
            circles: _circles,
            zoomControlsEnabled: false,
            initialCameraPosition: cameraPosition,
            onMapCreated: (GoogleMapController googleMapController) async {
              _googleMapController.complete(googleMapController);
              await setInitialLocation();
              if (startTrack && !endTrack) {
                showPinsOnMap();
              }
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 5, top: 25),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.topRight,
            child: Column(
              children: [
                ClipOval(
                  child: Material(
                    color: kSpringColor,
                    child: InkWell(
                      splashColor: kSecondaryColor,
                      onTap: () {
                        // TODO: bring my location to camera focus
                      },
                      child: const SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.my_location, color: kWhiteColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Material(
                  color: kSpringColor,
                  child: InkWell(
                    splashColor: kWhiteColor,
                    onTap: () async {
                      await zoomIn();
                    },
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.add, color: kWhiteColor),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                  height: 2,
                ),
                Material(
                  color: kSpringColor,
                  child: InkWell(
                    splashColor: kWhiteColor,
                    onTap: () async {
                      await zoomOut();
                    },
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.remove, color: kWhiteColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, deviceHeight * 0.73, 10, 25),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            width: deviceWidth,
            height: deviceHeight * 0.24,
            decoration: BoxDecoration(
              color: kSpringColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Track $trackStartTime',
                  style: const TextStyle(
                    color: kWhiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Column(
                      children: [
                        Consumer<LocationStatusProvider>(
                            builder: (context, gpsStateProvider, child) {
                              final bool locationEnabled = gpsStateProvider.locationState == LocationStatus.enabled ? true : false;

                              return Column(
                                children: [
                                  ClipOval(
                                    child: Material(
                                      color: kWhiteColor,
                                      child: SizedBox(
                                        height: 35,
                                        width: 35,
                                        child: Icon(
                                          locationEnabled ? Icons.location_on : Icons.location_off,
                                          color: kSpringColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: const Text(
                                      'GPS',
                                      style: TextStyle(
                                        color: kWhiteColor,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                        ),
                        const SizedBox(height: 5),
                        Consumer<BluetoothProvider>(
                            builder: (context, bluetoothProvider, child) {
                              final bool connectedToOBD = bluetoothProvider.isConnected();

                              return Column(
                                children: [
                                  ClipOval(
                                    child: Material(
                                      color: kWhiteColor,
                                      child: SizedBox(
                                        height: 35,
                                        width: 35,
                                        child: Icon(
                                          connectedToOBD ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                                          color: kSpringColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: const Text(
                                      'Bluetooth',
                                      style: TextStyle(
                                        color: kWhiteColor,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                          durationOfTrack,
                          style: const TextStyle(
                            color: kWhiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 24
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          'time'.toUpperCase(),
                          style: const TextStyle(
                            color: kWhiteColor
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              endTrack = true;
                              trackEndTime = DateTime.now().toUtc().toString().substring(0, 19);
                              debugPrint('tracking stopped at $trackEndTime');
                            });
                          },
                          child: ClipOval(
                            child: Material(
                              color: kErrorColor,
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: Icon(
                                  Icons.stop,
                                  color: kWhiteColor.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Column(
                          children: [
                            const Text(
                              '34.4 km/h', // TODO: change this to speed
                              style: TextStyle(
                                color: kWhiteColor,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            const Text(
                              'Avg speed',
                              style: TextStyle(
                                color: kWhiteColor
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(5), bottomRight: Radius.circular(4)),
                                color: kWhiteColor
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 1.5),
                              child: const Icon(
                                Icons.speed,
                                size: 18,
                                color: kSpringColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Column(
                          children: [
                            const Text(
                              '1 km', // TODO: change this to distance
                              style: TextStyle(
                                color: kWhiteColor,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            const Text(
                              'Distance',
                              style: TextStyle(
                                  color: kWhiteColor
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 5),
                              child: const ClipOval(
                                child: Material(
                                  color: kWhiteColor,
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Icon(
                                      Icons.trending_up_rounded,
                                      size: 18,
                                      color: kSpringColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future zoomIn() async {
    final GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.zoomIn());
  }

  Future zoomOut() async {
    final GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.zoomOut());
  }

  void showPinsOnMap() {
    final pinPoints = LatLng(
      currentLocation.latitude,
      currentLocation.longitude
    );

    final startPosition = LatLng(
      startLocation.latitude,
      startLocation.longitude
    );

    _markers.add(Marker(
      markerId: const MarkerId('source'),
      position: startPosition,
      icon: startIcon,
      zIndex: 2
    ));

    _circles.add(Circle(
      center: startPosition,
      circleId: const CircleId('source-circle'),
      strokeColor: kWhiteColor,
      strokeWidth: 2,
      radius: 5,
      fillColor: kBlueColor,
    ));

    _markers.add(Marker(
      markerId: const MarkerId('current'),
      position: pinPoints,
      icon: trackIcon,
      zIndex: 2
    ));

    _circles.add(Circle(
      center: pinPoints,
      circleId: const CircleId('current-circle'),
      strokeColor: kWhiteColor,
      strokeWidth: 2,
      radius: 5,
      fillColor: kBlueColor,
    ));

    setPolyLines();
  }

  void trackDuration() {
    final Duration duration = currentTime.difference(startTime);
    setState(() {
      durationOfTrack = duration.toString().split('.').first;
    });
    debugPrint(durationOfTrack.toString());
  }

  Future setPolyLines() async {
    final PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      travelMode: TravelMode.driving
    );

    // if (result.points.isEmpty) {
    //   debugPrint('error ${result.errorMessage.toString()}');
    // }

    if (result.points.isNotEmpty) {
      for (final PointLatLng pointLatLng in result.points) {
        _polyLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }

      if (mounted) {
        setState(() {
          _polyLines.add(Polyline(
              polylineId: const PolylineId('track'),
              width: 5,
              color: kBlueColor,
              points: _polyLineCoordinates
          ));
        });
      }
    }
  }

  Future updatePinOnMap() async {
    await setInitialLocation();
    LatLngBounds latLngBounds;

    if (startLocation.latitude < currentLocation.latitude && startLocation.longitude < currentLocation.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(startLocation.latitude, startLocation.longitude),
        northeast: LatLng(currentLocation.latitude, currentLocation.longitude)
      );
    }

    else if (startLocation.longitude < currentLocation.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(currentLocation.latitude, startLocation.longitude),
          northeast: LatLng(startLocation.latitude, currentLocation.longitude)
      );
    }

    else if (startLocation.latitude < currentLocation.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(startLocation.latitude, currentLocation.longitude),
          northeast: LatLng(currentLocation.latitude, startLocation.longitude)
      );
    }

    else {
      latLngBounds = LatLngBounds(
          southwest: LatLng(currentLocation.latitude, currentLocation.longitude),
          northeast: LatLng(startLocation.latitude, startLocation.longitude)
      );
    }

    debugPrint(latLngBounds.toString());

    final CameraPosition cameraPosition = CameraPosition(
      target: LatLng(
        currentLocation.latitude,
        currentLocation.longitude
      ),
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
    );

    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    if (mounted) {
      setState(() {
        final pinPoint = LatLng(currentLocation.latitude, currentLocation.longitude);

        _markers.removeWhere((element) => element.markerId.value == 'current');
        _circles.removeWhere((element) => element.circleId.value == 'current-circle');

        _markers.add(Marker(
          markerId: const MarkerId('current'),
          position: pinPoint,
          icon: trackIcon,
          zIndex: 2
        ));

        _circles.add(Circle(
          center: pinPoint,
          circleId: const CircleId('current-circle'),
          strokeColor: kWhiteColor,
          strokeWidth: 2,
          radius: 5,
          fillColor: kBlueColor,
        ));

      });
    }
  }

}
