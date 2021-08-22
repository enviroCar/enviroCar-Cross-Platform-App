import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants.dart';
import '../models/pointProperties.dart';

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
    position: destinationPosition,
  );

  markers.add(sourceMarker);
  markers.add(destinationMarker);

  return markers;
}

Set<Circle> getCircles(LatLng startPosition, LatLng destinationPosition) {
  final Set<Circle> circles = {};

  final Circle sourceCircle = Circle(
    circleId: const CircleId('source'),
    strokeColor: kWhiteColor,
    strokeWidth: 2,
    radius: 45,
    fillColor: kSpringColor,
    zIndex: 2,
    center: startPosition,
  );

  final Circle destinationCircle = Circle(
    circleId: const CircleId('destination'),
    strokeColor: kWhiteColor,
    strokeWidth: 2,
    radius: 45,
    fillColor: kSpringColor,
    zIndex: 2,
    center: destinationPosition,
  );

  circles.add(sourceCircle);
  circles.add(destinationCircle);

  return circles;
}

Future<Set<Polyline>> setPolyLines(List<PointProperties> properties) async {
  final Set<Polyline> polyLines = {};
  int len = properties.length;
  final PolylinePoints polylinePoints = PolylinePoints();
  final List<LatLng> polyLineCoordinates = [];
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

        polyLines.add(trackPolyline);
      }
    }
  }
  return polyLines;
}

double distanceBetweenCoordinates(LatLng startLocation, LatLng destinationLocation) {
  return GeolocatorPlatform.instance.distanceBetween(startLocation.latitude, startLocation.longitude, destinationLocation.latitude, destinationLocation.longitude) / 1000;
}