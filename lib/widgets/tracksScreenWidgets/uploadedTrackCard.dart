import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../globals.dart';
import '../../constants.dart';
import '../../utils/enums.dart';
import '../../models/track.dart';
import '../../utils/mapFunctions.dart';
import '../../models/localTrackModel.dart';
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
  Set<Polyline> polyLines;

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
    ),
  );

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
    final TextStyle textStyle = Theme.of(context).textTheme.headline1;

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
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(deviceWidth * 0.018),
                topRight: Radius.circular(deviceWidth * 0.018),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
                  child: Text(
                    widget.track.name,
                    style: const TextStyle(
                      color: kWhiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Consumer<TracksProvider>(
                    builder: (context, tracksProvider, child) {
                      final bool isListFetched =
                          tracksProvider.getListSetStatus;

                      return PopupMenuButton(
                        enabled: true,
                        onSelected: (int index) {
                          if (index == 0) {
                            _logger.i('Going to track details screen');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TrackDetailsScreen(
                                  track: widget.track,
                                  trackType: TrackType.Remote,
                                  index: widget.index,
                                ),
                              ),
                            );
                          } else if (index == 1) {
                            _logger.i(
                              'Call function to export track data as an excel file',
                            );
                            tracksProvider.exportTrack(widget.index, false);
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: 0,
                            child: Text(
                              'Show Details',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: textStyle.color,
                              ),
                            ),
                          ),
                          if (isListFetched)
                            PopupMenuItem(
                              value: 1,
                              child: Text(
                                'Export Track',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: textStyle.color,
                                ),
                              ),
                            ),
                        ],
                        child: const Icon(
                          Icons.more_vert_outlined,
                          color: kWhiteColor,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _logger.i('Going to track details screen');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrackDetailsScreen(
                    track: widget.track,
                    trackType: TrackType.Remote,
                    index: widget.index,
                  ),
                ),
              );
            },
            child: SizedBox(
              height: deviceHeight * 0.2,
              width: double.infinity,
              child: Consumer<TracksProvider>(
                builder: (context, tracksProvider, child) {
                  LocalTrackModel trackModel;
                  LatLng startPosition;
                  LatLng destinationPosition;

                  final bool isListFetched = tracksProvider.getListSetStatus;

                  if (isListFetched) {
                    trackModel = tracksProvider.getTracksWithId()[widget.index];

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
                      circles: getCircles(startPosition, destinationPosition),
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
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrackDetailsScreen(
                    track: widget.track,
                    trackType: TrackType.Remote,
                    index: widget.index,
                  ),
                ),
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
                      Text(
                        'Duration',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: textStyle.color,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.track.length != null
                            ? '${widget.track.length.toStringAsFixed(2)}km'
                            : '0km',
                        style: const TextStyle(
                          color: kSpringColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Distance',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: textStyle.color,
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

  void animateCamera(LatLng startLocation, LatLng destinationLocation) {
    if (distanceBetweenCoordinates(startLocation, destinationLocation) > 0.1) {
      setState(() {
        _googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            getLatLngBounds(
              startLocation,
              destinationLocation,
            ),
            30,
          ),
        );
      });
    }
  }
}
