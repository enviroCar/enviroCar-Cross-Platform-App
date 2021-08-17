import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../../globals.dart';
import '../../constants.dart';
import '../../models/track.dart';
import '../../models/localTrackModel.dart';
import '../../models/pointProperties.dart';
import '../../providers/tracksProvider.dart';
import '../../screens/trackDetailsScreen.dart';

class UploadedTrackCard extends StatefulWidget {
  final Track track;
  final int index;

  const UploadedTrackCard({@required this.track, @required this.index});

  @override
  _UploadedTrackCardState createState() => _UploadedTrackCardState();
}

class _UploadedTrackCardState extends State<UploadedTrackCard> {
  GoogleMapController _googleMapController;
  PolylinePoints polylinePoints;
  Set<Polyline> polyLines;
  List<LatLng> polyLineCoordinates;

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
    ),
  );

  @override
  void initState() {
    polyLines = {};
    polyLineCoordinates = [];
    polylinePoints = PolylinePoints();
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceWidth * 0.9,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[350],
            blurRadius: 3.0,
            spreadRadius: 1.0,
            offset: const Offset(-2, 2),
          ),
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: kSpringColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(deviceWidth * 0.018), topRight: Radius.circular(deviceWidth * 0.018)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Track ',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: kWhiteColor,
                      ),
                      children: [
                        TextSpan(
                          text: widget.track.begin.toUtc().toString().replaceFirst('.000Z', ''),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  child: PopupMenuButton(
                    enabled: true,
                    onSelected: (int index) {
                      if (index == 0) {
                        _logger.i('Going to track details screen');
                        Navigator.of(context).pushNamed(
                          TrackDetailsScreen.routeName,
                          arguments: widget.track,
                        );
                      }
                      else if (index == 1) {
                        // TODO: function to export track
                        debugPrint('export track tapped');
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 0,
                        child: Text(
                          'Show Details',
                        ),
                      ),
                      const PopupMenuItem(
                        value: 1,
                        child: Text(
                          'Export Track',
                        ),
                      ),
                    ],
                    child: const Icon(
                      Icons.more_vert_outlined,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _logger.i('Going to track details screen');
              Navigator.of(context).pushNamed(
                TrackDetailsScreen.routeName,
                arguments: widget.track,
              );
            },
            child: SizedBox(
              height: deviceHeight * 0.2,
              width: double.infinity,
              child: Consumer<TracksProvider>(
                builder: (context, tracksProvider, child) {
                  LocalTrackModel trackModel;
                  LatLng startPosition, destinationPosition;

                  final bool isListFetched = tracksProvider.getListSetStatus;

                  if (isListFetched) {
                    trackModel = tracksProvider.getTracksWithId()[widget.index];

                    startPosition = LatLng(
                        trackModel.getProperties.values.first.latitude,
                        trackModel.getProperties.values.first.longitude
                    );

                    destinationPosition = LatLng(
                        trackModel.getProperties.values.last.latitude,
                        trackModel.getProperties.values.last.longitude
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
                          startPosition.longitude
                        ),
                        markers: getMarkers(startPosition, destinationPosition),
                        polylines: polyLines,
                        onMapCreated: (GoogleMapController googleMapController) async {
                          _googleMapController = googleMapController;
                          animateCamera(startPosition, destinationPosition);
                          setPolyLines(trackModel.properties.values.toList());
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
                }
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                TrackDetailsScreen.routeName,
                arguments: widget.track,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.track.end
                            .difference(widget.track.begin)
                            .toString()
                            .replaceFirst('.000000', ''),
                        style: const TextStyle(
                          color: kSpringColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Text(
                        'Duration',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.track.length != null ? '${widget.track.length.toStringAsFixed(2)}km' : '0km',
                        style: const TextStyle(
                          color: kSpringColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Text(
                        'Distance',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LatLngBounds getLatLngBounds(LatLng startLocation, LatLng destinationLocation) {
    LatLngBounds latLngBounds;

    if (startLocation.latitude < destinationLocation.latitude && startLocation.longitude < destinationLocation.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(
              startLocation.latitude,
              startLocation.longitude
          ),
          northeast: LatLng(
              destinationLocation.latitude,
              destinationLocation.longitude
          )
      );
    }

    else if (startLocation.latitude < destinationLocation.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(
              startLocation.latitude,
              destinationLocation.longitude
          ),
          northeast: LatLng(
              destinationLocation.latitude,
              startLocation.longitude
          )
      );
    }

    else if (startLocation.longitude < destinationLocation.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(
              destinationLocation.latitude,
              startLocation.longitude
          ),
          northeast: LatLng(
              startLocation.latitude,
              destinationLocation.longitude
          )
      );
    }

    else {
      latLngBounds = LatLngBounds(
          southwest: LatLng(
              destinationLocation.latitude,
              destinationLocation.longitude
          ),
          northeast: LatLng(
              startLocation.latitude,
              startLocation.longitude
          )
      );
    }

    return latLngBounds;
  }

  CameraPosition getInitialCameraPosition(double latitude, double longitude) {
    final CameraPosition cameraPosition = CameraPosition(
      target: LatLng(
        latitude,
        longitude
      ),
      zoom: 14
    );
    return cameraPosition;
  }

  Set<Marker> getMarkers(LatLng startPosition, LatLng destinationPosition) {
    final Set<Marker> markers = {};

    final Marker sourceMarker = Marker(
        markerId: const MarkerId('source'),
        position: startPosition,
    );

    final Marker destinationMarker = Marker(
      markerId: const MarkerId('destination'),
      position: startPosition,
    );

    markers.add(sourceMarker);
    markers.add(destinationMarker);

    return markers;
  }

  void animateCamera(LatLng startLocation, LatLng destinationLocation) {
    setState(() {
      _googleMapController.animateCamera(CameraUpdate.newLatLngBounds(getLatLngBounds(
          startLocation,
          startLocation
      ), 10));
    });
  }

  Future setPolyLines(List<PointProperties> properties) async {
    int len = properties.length;
    if (len > 1) {
      for (final int i = 0; i < len - 1; len++) {
        final PointLatLng origin = PointLatLng(properties[i].latitude, properties[i].longitude);
        final PointLatLng destination = PointLatLng(properties[i + 1].latitude, properties[i + 1].longitude);
        final PolylineResult polylineResult = await polylinePoints.getRouteBetweenCoordinates(
          googleAPIKey,
          origin,
          destination,
          travelMode: TravelMode.driving
        );

        if (polylineResult.points.isEmpty) {
          // debugPrint('error is ${polylineResult.errorMessage}'); You must enable Billing on the Google Cloud Project at https://console.cloud.google.com/project/_/billing/enable Learn more at https://developers.google.com/maps/gmp-get-started
        }
        else {
          for (final PointLatLng pointLatLng in polylineResult.points) {
            final LatLng latLng = LatLng(pointLatLng.latitude, pointLatLng.longitude);
            polyLineCoordinates.add(latLng);
          }

          final Polyline trackPolyline = Polyline(
              polylineId: const PolylineId('track'),
              width: 5,
              color: kBlueColor,
              points: polyLineCoordinates
          );

          setState(() {
            polyLines.add(trackPolyline);
          });
        }
      }
    }
  }

}
