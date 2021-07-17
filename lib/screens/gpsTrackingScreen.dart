import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants.dart';
import '../globals.dart';
import '../providers/bluetoothProvider.dart';
import '../utils/enums.dart';
import '../providers/locationStatusProvider.dart';
import '../providers/gpsTrackProvider.dart';
import '../widgets/gpsTrackingWidgets/detailsIcon.dart';
import '../widgets/gpsTrackingWidgets/statusIndicatorWidget.dart';
import '../widgets/gpsTrackingWidgets/timeWidget.dart';

class GpsTrackingScreen extends StatefulWidget {
  static String routeName = '/gpsTracking';

  @override
  _GpsTrackingScreenState createState() => _GpsTrackingScreenState();
}

class _GpsTrackingScreenState extends State<GpsTrackingScreen> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  GpsTrackProvider gpsTrackProvider;

  @override
  void initState() {
    final provider = Provider.of<GpsTrackProvider>(context, listen: false);
    provider.trackScreenMounted(true);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    gpsTrackProvider = Provider.of<GpsTrackProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    gpsTrackProvider.trackScreenMounted(false);
    if (gpsTrackProvider.getEndTrackStatus) {
      gpsTrackProvider.resetAllValues();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (gpsTrackProvider.needsRebuild) {
      gpsTrackProvider.setUpMap();
    }

    final bool showMap = gpsTrackProvider.locationDetermined;

    return Scaffold(
      body: showMap ? Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            markers: gpsTrackProvider.getMarkers,
            polylines: gpsTrackProvider.getPolyLines,
            circles: gpsTrackProvider.getCircles,
            zoomControlsEnabled: false,
            initialCameraPosition: gpsTrackProvider.getCameraPosition,
            onMapCreated: (GoogleMapController googleMapController) async {
              _googleMapController.complete(googleMapController);
              await gpsTrackProvider.setMapController(_googleMapController.future);
              gpsTrackProvider.addMarkersAndCircles();
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
                      onTap: () async {
                        await myLocation();
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
                  'Track ${gpsTrackProvider.trackId}',
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

                              return StatusIndicatorWidget(
                                title: 'gps'.toUpperCase(),
                                iconData: locationEnabled ? Icons.location_on : Icons.location_off,
                              );
                            }
                        ),
                        const SizedBox(height: 5),
                        Consumer<BluetoothProvider>(
                            builder: (context, bluetoothProvider, child) {
                              final bool connectedToOBD = bluetoothProvider.isConnected();

                              return StatusIndicatorWidget(
                                title: 'Bluetooth',
                                iconData: connectedToOBD ? Icons.bluetooth : Icons.bluetooth_disabled,
                              );
                            }
                        ),
                      ],
                    ),
                    const Spacer(),
                    TimeWidget(
                      duration: gpsTrackProvider.getTrackDuration,
                      function: () {
                        gpsTrackProvider.stopTrack();
                        Navigator.of(context).pop();
                      },
                    ),
                    const Spacer(),
                    Column(
                      children: const [
                        DetailsIcon(
                          title: 'Avg speed',
                          data: '40 km/h',
                          iconData: Icons.speed,
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        DetailsIcon(
                          title: 'Distance',
                          data: '1 km',
                          iconData: Icons.trending_up_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ) : const Center(
        child: CircularProgressIndicator(),
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

  Future myLocation() async {
    final GoogleMapController mapController = await _googleMapController.future;
    final CameraPosition cameraPosition = gpsTrackProvider.getCameraPosition;
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

}
