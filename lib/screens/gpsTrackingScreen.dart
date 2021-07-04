import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GpsTrackingScreen extends StatefulWidget {
  static String routeName = '/gpsTracking';

  @override
  _GpsTrackingScreenState createState() => _GpsTrackingScreenState();
}

class _GpsTrackingScreenState extends State<GpsTrackingScreen> {
  Completer<GoogleMapController> _googleMapController = Completer();
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polyLines = Set<Polyline>();
  List<LatLng> _polyLineCoordinates = [];
  PolylinePoints _polylinePoints;

  String googleAPIKey = "AIzaSyDDTeCTv3rjbgtP4YQB_zlLGeMOvYcLAO0";

  LocationData startLocation;
  LocationData currentLocation;

  Location _location;

  BitmapDescriptor trackIcon;

  @override
  void initState() {
    _location = new Location();
    _polylinePoints = new PolylinePoints();

    _location.onLocationChanged.listen(listenToLocationUpdates);

    setTrackIcon();
    setInitialLocation();

    setTrackIcon();

    super.initState();
  }

  void listenToLocationUpdates(LocationData locationData) {
    currentLocation = locationData;
    updatePinOnMap();
  }

  Future setInitialLocation() async {
    currentLocation = await _location.getLocation();
    startLocation = currentLocation;
  }

  void setTrackIcon() async {
    trackIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/tracking_pin.png'
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(42.747932,-71.167889),
      zoom: 16,
      tilt: 80,
      bearing: 16
    );

    if (startLocation != null) {
      cameraPosition = CameraPosition(
          target: LatLng(
            startLocation.latitude,
            startLocation.longitude
          ),
          zoom: 16,
          tilt: 80,
          bearing: 16
      );
    }

    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: true,
        compassEnabled: true,
        tiltGesturesEnabled: true,
        markers: _markers,
        polylines: _polyLines,
        mapType: MapType.normal,
        initialCameraPosition: cameraPosition,
        onMapCreated: (GoogleMapController googleMapController) async {
          _googleMapController.complete(googleMapController);
          await setInitialLocation();
          showPinsOnMap();
        },
      ),
    );
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
    ));

    _markers.add(Marker(
      markerId: MarkerId('current'),
      position: pinPoints,
      icon: trackIcon
    ));

    setPolyLines();
  }

  void setPolyLines() async {
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(startLocation.longitude, startLocation.longitude),
      PointLatLng(currentLocation.latitude, currentLocation.longitude)
    );

    if (result != null && result.points.isNotEmpty) {
      print('inside result');
      for (PointLatLng pointLatLng in result.points) {
        _polyLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }

      if (mounted) {
        setState(() {
          _polyLines.add(Polyline(
              polylineId: PolylineId('track'),
              width: 5,
              color: Color.fromARGB(255, 40, 122, 198),
              points: _polyLineCoordinates
          ));
        });
      }
    }
  }

  void updatePinOnMap() async {
    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(
            currentLocation.latitude,
            currentLocation.longitude
        ),
        zoom: 16,
        tilt: 80,
        bearing: 16
    );

    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    if (mounted) {
      setState(() {
        var pinPoint = LatLng(currentLocation.latitude, currentLocation.longitude);

        _markers.removeWhere((element) => element.markerId.value == 'current');

        _markers.add(Marker(
          markerId: MarkerId('current'),
          position: pinPoint,
          icon: trackIcon
        ));

      });
    }
  }

}