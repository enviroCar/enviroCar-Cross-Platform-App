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
  Completer<GoogleMapController> _googleMapController = Completer();
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polyLines = Set<Polyline>();
  Set<Circle> _circles = Set<Circle>();
  List<LatLng> _polyLineCoordinates = [];
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
    _location = new Location();
    _polylinePoints = new PolylinePoints();

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
    getAddress(currentLocation.latitude, currentLocation.longitude);
    startLocation = currentLocation;
  }

  void setTrackIcon() async {
    trackIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/tracking_pin.png'
    );

    startIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/source_pin.png'
    );
  }

  Future getAddress(double latitude, double longitude) async {
    Response response = await get(Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleAPIKey'));
    // print('response is ${response.body}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    CameraPosition cameraPosition = CameraPosition(
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
            compassEnabled: true,
            tiltGesturesEnabled: true,
            markers: _markers,
            polylines: _polyLines,
            circles: _circles,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
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
            margin: EdgeInsets.only(right: 5, top: 25),
            padding: EdgeInsets.all(10),
            alignment: Alignment.topRight,
            child: Container(
              child: Column(
                children: [
                  ClipOval(
                    child: Material(
                      color: kSpringColor,
                      child: InkWell(
                        splashColor: kSecondaryColor,
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(Icons.my_location, color: kWhiteColor),
                        ),
                        onTap: () {
                          // TODO: bring my location to camera focus
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Material(
                      color: kSpringColor,
                      child: InkWell(
                        splashColor: kWhiteColor,
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(Icons.add, color: kWhiteColor),
                        ),
                        onTap: () async {
                          await zoomIn();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    height: 2,
                  ),
                  Container(
                    child: Material(
                      color: kSpringColor,
                      child: InkWell(
                        splashColor: kWhiteColor,
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(Icons.remove, color: kWhiteColor),
                        ),
                        onTap: () async {
                          await zoomOut();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, deviceHeight * 0.73, 10, 25),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            width: deviceWidth,
            height: deviceHeight * 0.24,
            decoration: BoxDecoration(
              color: kSpringColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    'Track $trackStartTime',
                    style: TextStyle(
                      color: kWhiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 20
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Column(
                      children: [
                        Consumer<LocationStatusProvider>(
                            builder: (context, gpsStateProvider, child) {
                              bool locationEnabled = gpsStateProvider.locationState == LocationStatus.enabled ? true : false;

                              return Column(
                                children: [
                                  Container(
                                    child: ClipOval(
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
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
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
                        SizedBox(height: 5),
                        Consumer<BluetoothProvider>(
                            builder: (context, bluetoothProvider, child) {
                              bool connectedToOBD = bluetoothProvider.isConnected();

                              return Column(
                                children: [
                                  Container(
                                    child: ClipOval(
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
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
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
                    Spacer(),
                    Column(
                      children: [
                        Container(
                          child: Text(
                            durationOfTrack,
                            style: TextStyle(
                              color: kWhiteColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 24
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Container(
                          child: Text(
                            'time'.toUpperCase(),
                            style: TextStyle(
                              color: kWhiteColor
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: GestureDetector(
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
                            onTap: () {
                              setState(() {
                                endTrack = true;
                                trackEndTime = DateTime.now().toUtc().toString().substring(0, 19);
                                debugPrint('tracking stopped at $trackEndTime');
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              child: Text(
                                '34.4 km/h', // TODO: change this to speed
                                style: TextStyle(
                                  color: kWhiteColor,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                'Avg speed',
                                style: TextStyle(
                                  color: kWhiteColor
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(5), bottomRight: Radius.circular(4)),
                                color: kWhiteColor
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 1.5),
                              child: Icon(
                                Icons.speed,
                                size: 18,
                                color: kSpringColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Column(
                          children: [
                            Container(
                              child: Text(
                                '1 km', // TODO: change this to distance
                                style: TextStyle(
                                  color: kWhiteColor,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                'Distance',
                                style: TextStyle(
                                    color: kWhiteColor
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              child: ClipOval(
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
    var pinPoints = LatLng(
      currentLocation.latitude,
      currentLocation.longitude
    );

    var startPosition = LatLng(
      startLocation.latitude,
      startLocation.longitude
    );

    _markers.add(Marker(
      markerId: MarkerId('source'),
      position: startPosition,
      icon: startIcon,
      zIndex: 2
    ));

    _circles.add(Circle(
      center: startPosition,
      visible: true,
      circleId: CircleId('source-circle'),
      strokeColor: kWhiteColor,
      strokeWidth: 2,
      radius: 5,
      fillColor: kBlueColor,
    ));

    _markers.add(Marker(
      markerId: MarkerId('current'),
      position: pinPoints,
      icon: trackIcon,
      zIndex: 2
    ));

    _circles.add(Circle(
      center: pinPoints,
      visible: true,
      circleId: CircleId('current-circle'),
      strokeColor: kWhiteColor,
      strokeWidth: 2,
      radius: 5,
      fillColor: kBlueColor,
    ));

    setPolyLines();
  }

  void trackDuration() {
    Duration duration = currentTime.difference(startTime);
    setState(() {
      durationOfTrack = duration.toString().split('.').first;
    });
    debugPrint('${durationOfTrack.toString()}');
  }

  void setPolyLines() async {
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      travelMode: TravelMode.driving
    );

    // if (result.points.isEmpty) {
    //   debugPrint('error ${result.errorMessage.toString()}');
    // }

    if (result.points.isNotEmpty) {
      for (PointLatLng pointLatLng in result.points) {
        _polyLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }

      if (mounted) {
        setState(() {
          _polyLines.add(Polyline(
              polylineId: PolylineId('track'),
              width: 5,
              color: kBlueColor,
              points: _polyLineCoordinates
          ));
        });
      }
    }
  }

  void updatePinOnMap() async {
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

    CameraPosition cameraPosition = CameraPosition(
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
        var pinPoint = LatLng(currentLocation.latitude, currentLocation.longitude);

        _markers.removeWhere((element) => element.markerId.value == 'current');
        _circles.removeWhere((element) => element.circleId.value == 'current-circle');

        _markers.add(Marker(
          markerId: MarkerId('current'),
          position: pinPoint,
          icon: trackIcon,
          zIndex: 2
        ));

        _circles.add(Circle(
          center: pinPoint,
          visible: true,
          circleId: CircleId('current-circle'),
          strokeColor: kWhiteColor,
          strokeWidth: 2,
          radius: 5,
          fillColor: kBlueColor,
        ));

      });
    }
  }

}
