import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';

class MapWidget extends StatefulWidget {
  final Function initializeLocation;

  const MapWidget({@required this.initializeLocation});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Position>(
      stream: Geolocator.getPositionStream(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final Position position = Position.fromMap(snapshot.data);
          return Center(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(position.latitude, position.longitude),
                zoom: 12.0,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/dajayk12/ckn3p0jvx0y6j17qe3ng3t5sn/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZGFqYXlrMTIiLCJhIjoiY2tuM29tcGd3MGIzaDJ2bzB6cXB5OTFpaCJ9.Lyi9ErZba0U-YKhmshQV2w",
                  additionalOptions: {
                    'accessToken':
                        'pk.eyJ1IjoiZGFqYXlrMTIiLCJhIjoiY2tuM29tcGd3MGIzaDJ2bzB6cXB5OTFpaCJ9.Lyi9ErZba0U-YKhmshQV2w',
                    'id': 'mapbox.streets',
                  },
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 50.0,
                      height: 50.0,
                      point: LatLng(position.latitude, position.longitude),
                      builder: (ctx) => const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }

        // When GPS is turned off while on Map Screen
        else if (snapshot.hasError) {
          widget.initializeLocation();
          return Container();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
