import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../globals.dart';
import '../../constants.dart';
import '../../utils/enums.dart';
import '../../utils/mapFunctions.dart';
import '../../models/localTrackModel.dart';
import '../../providers/tracksProvider.dart';
import '../../hiveDB/localTracksCollection.dart';
import '../../providers/localTracksProvider.dart';

class StackedMapButton extends StatefulWidget {
  final TrackType trackType;
  final int index;

  const StackedMapButton({@required this.trackType, @required this.index});

  @override
  _StackedMapButtonState createState() => _StackedMapButtonState();
}

class _StackedMapButtonState extends State<StackedMapButton> {
  double buttonDiameter = 55;
  GoogleMapController _googleMapController;
  Set<Polyline> polyLines;

  @override
  void initState() {
    polyLines = {};
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (deviceHeight * 0.3) + buttonDiameter / 2,
      width: double.infinity,
      child: Stack(
        children: [
          SizedBox(
            height: deviceHeight * 0.3,
            width: double.infinity,
            child: widget.trackType == TrackType.Local
                ? Consumer<LocalTracksProvider>(
                    builder: (context, tracksProvider, child) {
                      final LocalTrackModel trackModel =
                          LocalTracks.getTrackAtIndex(widget.index);
                      LatLng startPosition;
                      LatLng destinationPosition;

                      startPosition = LatLng(
                        trackModel.getProperties.values.first.latitude,
                        trackModel.getProperties.values.first.longitude,
                      );

                      destinationPosition = LatLng(
                        trackModel.getProperties.values.last.latitude,
                        trackModel.getProperties.values.last.longitude,
                      );

                      return GoogleMap(
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        scrollGesturesEnabled: false,
                        zoomGesturesEnabled: false,
                        initialCameraPosition: getInitialCameraPosition(
                          startPosition.latitude,
                          startPosition.longitude,
                        ),
                        markers: getMarkers(startPosition, destinationPosition),
                        polylines: polyLines,
                        onMapCreated:
                            (GoogleMapController googleMapController) async {
                          _googleMapController = googleMapController;
                          polyLines = await setPolyLines(
                            trackModel.properties.values.toList(),
                          );
                          animateCamera(startPosition, destinationPosition);
                        },
                      );
                    },
                  )
                : Consumer<TracksProvider>(
                    builder: (context, tracksProvider, child) {
                      LocalTrackModel trackModel;
                      LatLng startPosition;
                      LatLng destinationPosition;

                      final bool isListFetched =
                          tracksProvider.getListSetStatus;

                      if (isListFetched) {
                        trackModel =
                            tracksProvider.getTracksWithId()[widget.index];

                        startPosition = LatLng(
                          trackModel.getProperties.values.first.latitude,
                          trackModel.getProperties.values.first.longitude,
                        );

                        destinationPosition = LatLng(
                          trackModel.getProperties.values.last.latitude,
                          trackModel.getProperties.values.last.longitude,
                        );
                      }

                      if (isListFetched) {
                        return GoogleMap(
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          scrollGesturesEnabled: false,
                          zoomGesturesEnabled: false,
                          initialCameraPosition: getInitialCameraPosition(
                            startPosition.latitude,
                            startPosition.longitude,
                          ),
                          markers:
                              getMarkers(startPosition, destinationPosition),
                          polylines: polyLines,
                          onMapCreated:
                              (GoogleMapController googleMapController) async {
                            _googleMapController = googleMapController;
                            polyLines = await setPolyLines(
                              trackModel.properties.values.toList(),
                            );
                            animateCamera(startPosition, destinationPosition);
                          },
                        );
                      } else {
                        return const Center(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              color: kSpringColor,
                            ),
                          ),
                        );
                      }
                    },
                  ),
          ),
          Positioned(
            top: (deviceHeight * 0.3) - buttonDiameter / 2,
            right: (30) / 2,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                decoration: const BoxDecoration(
                  color: kSpringColor,
                  shape: BoxShape.circle,
                ),
                height: buttonDiameter,
                width: buttonDiameter,
                child: const Icon(
                  Icons.map,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void animateCamera(LatLng startLocation, LatLng destinationLocation) {
    if (distanceBetweenCoordinates(startLocation, destinationLocation) > 0.1) {
      setState(() {
        _googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            getLatLngBounds(
              startLocation,
              destinationLocation,
            ),
            60,
          ),
        );
      });
    }
  }
}
